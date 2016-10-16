defmodule LingualeoGateway.Methods.SignIn do
  @moduledoc """
  Contains logic to perform sign in method
  """

  @url "http://api.lingualeo.com/api/login"

  @doc """
  Calls sign in method performing
  """
  def call(email, password) do
    http_response = do_http_request(email, password)
    response_hash = http_response |> extract_json_body
    cookies = http_response |> extract_cookies
    decide_about_response(response_hash, cookies)
  end

  defp do_http_request(email, password) do
    HTTPotion.post @url <> "?email=#{email}&password=#{password}"
  end

  defp extract_json_body(%HTTPotion.Response{body: json_str}) do
    {:ok, response_hash} = json_str
              |> JSX.decode([{:labels, :atom}])
    response_hash
  end

  defp extract_cookies(%HTTPotion.Response{headers: headers}) do
    {:ok, cookies} = headers |> HTTPotion.Headers.fetch(:"set-cookie")
    cookies
  end

  defp decide_about_response(%{error_code: _, error_msg: error_msg} = response_hash, cookies) do
    prepare_response_tuple(:error, error_msg, response_hash, cookies)
  end

  defp decide_about_response(response_hash, cookies) do
    prepare_response_tuple(:ok, "OK", response_hash, cookies)
  end

  defp prepare_response_tuple(response_status, message, response_hash, cookies) do
    {response_status, message, response_hash, cookies}
  end
end
