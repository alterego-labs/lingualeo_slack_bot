defmodule LingualeoGateway.HttpResponse do
  @moduledoc """
  Represents a http response struct.
 
  Encapsulates all needed information which can be used in the other layers.
  Can be built from 3rd party http responses structs, such as HTTPotion library.
  """

  defstruct [:response_hash, :cookies, :is_success, :error_msg]

  @doc """
  Builds a http response record from a 3rd party one
  """
  def from_3rdparty_response(%HTTPotion.Response{body: json_str, headers: headers}) do
    {:ok, response_hash} = json_str |> JSX.decode([{:labels, :atom}])
    {:ok, cookies} = headers |> HTTPotion.Headers.fetch(:"set-cookie")
    is_success = !(response_hash |> Map.has_key?(:error_code))
    error_msg = response_hash |> Map.get(:error_msg, "")
    %__MODULE__{
      response_hash: response_hash,
      cookies: cookies,
      is_success: is_success,
      error_msg: error_msg
    }
  end
end
