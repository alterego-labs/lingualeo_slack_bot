defmodule LingualeoGateway.HttpResponse do
  @moduledoc """
  Represents a http response struct.
 
  Encapsulates all needed information which can be used in the other layers.
  Can be built from 3rd party http responses structs, such as HTTPotion library.
  """

  defstruct [:response_hash, :cookies, :is_success, :error_msg, :status_code, :raw_body]

  @doc """
  Builds a http response record from a 3rd party one
  """
  def from_3rdparty_response(%HTTPotion.Response{body: json_str, headers: headers, status_code: status_code}) do
    response_hash = decode_raw_body(json_str)
    {:ok, cookies} = HTTPotion.Headers.fetch(headers, :"set-cookie")
    error_code = Map.get(response_hash, :error_code, 200)
    error_msg = Map.get(response_hash, :error_msg, "")
    status_code = resolve_status_code(error_code, status_code)
    is_success = status_code == 200
    %__MODULE__{
      response_hash: response_hash,
      raw_body: json_str,
      cookies: cookies,
      is_success: is_success,
      error_msg: error_msg,
      status_code: resolve_status_code(error_code, status_code)
    }
  end

  defp decode_raw_body(""), do: %{}
  defp decode_raw_body(json_str) do
    {:ok, response_hash} = JSX.decode(json_str, [{:labels, :atom}])
    response_hash
  end

  @doc """
  Resolves the final status code value.
  
  This logic is needed because of LinguaLeo API returns error responses as _200 OK_. But could be
  some situations when the HTTP response status code does not equal 200, so it must be returned
  instead the error code from the response hash.
  """
  defp resolve_status_code(error_code, status_code) when error_code == status_code, do: status_code
  defp resolve_status_code(_error_code, status_code) when status_code != 200, do: status_code
  defp resolve_status_code(error_code, _status_code), do: error_code
end
