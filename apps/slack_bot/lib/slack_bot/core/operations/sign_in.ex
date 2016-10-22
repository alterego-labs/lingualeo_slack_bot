defmodule SlackBot.Core.Operations.SignIn do
  @moduledoc """
  Makes sign in operation to the Lingualeo API
  """

  alias SlackBot.Core.{IncomeMessage}

  @doc """
  Calls sign in operation
  """
  @spec call(IncomeMessage.t) :: :ok | {:error, :invalid_message | :invalid_credentials}
  def call(%IncomeMessage{} = message) do
    message
    |> IncomeMessage.sign_in_credentials
    |> do_lingualeo_api_request
    |> process_with_storage(message)
  end

  defp do_lingualeo_api_request({:error, _reason}), do: {:error, :invalid_message}
  defp do_lingualeo_api_request({:ok, %{email: email, password: password}}) do
    LingualeoGateway.API.sign_in(email, password)
  end

  defp process_with_storage({:error, _reason} = error_response, _message), do: error_response
  defp process_with_storage({:error, _, _, _}, _message), do: {:error, :invalid_credentials}
  defp process_with_storage({:ok, _status_message, response_hash, cookies}, %IncomeMessage{} = message) do
    {:ok, str_response_hash} = JSX.encode(response_hash)
    {:ok, str_cookies} = JSX.encode(cookies)
    message
    |> IncomeMessage.sender_name
    |> Storage.API.user_by_login_first_or_create
    |> Storage.API.user_update(%{response_hash: str_response_hash, cookies: str_cookies})
    :ok
  end
end
