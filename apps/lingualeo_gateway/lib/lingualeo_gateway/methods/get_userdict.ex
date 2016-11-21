defmodule LingualeoGateway.Methods.GetUserdict do
  @moduledoc """
  Contains a logic to request user dictionary via LinguaLeo API
  """

  use Logging.Producer

  import LingualeoGateway.Core.Utils

  alias LingualeoGateway.HttpResponse
  alias LingualeoGateway.Core.{UserDict}

  @type error_code :: atom

  @url "http://api.lingualeo.com/userdict?port=1&offset=%{offset}"

  @doc """
  Calls user's dictionary method performing
  """
  @spec call([String.t], pos_integer) :: {:ok, UserDict.t} | {:error, error_code}
  def call(cookies, offset) do
    cookies_string = cookies |> Enum.join("; ")
    logging_info "Trying to get user's dictionary... Cookies are `#{cookies_string}`, offset is #{to_string(offset)}"
    {cookies_string, offset}
    |> do_http_request
    |> HttpResponse.from_3rdparty_response
    |> decide_about_method_response
  end

  defp do_http_request({cookie_string, offset}) do
    @url
    |> interpolate_string([offset: offset])
    |> HTTPotion.get([headers: ["Cookie": cookie_string]])
  end

  defp decide_about_method_response(%HttpResponse{is_success: true} = http_response) do
    logging_info "Successfully got a dictionary: response => `#{http_response.raw_body}`"
    user_dict = UserDict.build_from(http_response)
    {:ok, user_dict}
  end
  defp decide_about_method_response(%HttpResponse{is_success: false, status_code: 401}) do
    logging_info "Error while getting user dictionary: user is unauthorized!"
    {:error, :unauthorized}
  end
end
