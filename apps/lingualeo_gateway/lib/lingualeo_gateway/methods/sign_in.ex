defmodule LingualeoGateway.Methods.SignIn do
  @moduledoc """
  Contains logic to perform sign in method
  """

  use Logging.Producer

  @url "http://api.lingualeo.com/api/login"

  @doc """
  Calls sign in method performing
  """
  def call(email, password) do
    logging_info "Trying to sign in user with email `#{email}` and password `#{password}`"
    do_http_request(email, password)
    |> LingualeoGateway.HttpResponse.from_3rdparty_response
    |> decide_about_response
  end

  defp do_http_request(email, password) do
    HTTPotion.post @url <> "?email=#{email}&password=#{password}"
  end

  defp decide_about_response(%LingualeoGateway.HttpResponse{is_success: true} = response) do
    logging_info "sign in result is OK"
    prepare_response_tuple(:ok, "OK", response.response_hash, response.cookies)
  end

  defp decide_about_response(%LingualeoGateway.HttpResponse{is_success: false} = response) do
    logging_info "sign in result is NOK"
    prepare_response_tuple(:error, response.error_msg, response.response_hash, response.cookies)
  end

  defp prepare_response_tuple(response_status, message, response_hash, cookies) do
    {response_status, message, response_hash, cookies}
  end
end
