defmodule SlackBot.Resolver do
  @moduledoc """
  Makes decision about what action must be performed based on user state and message information.
  """

  alias SlackBot.Core.{IncomeMessage, CurrentUserState}
  alias SlackBot.API

  @doc """
  Runs resolving procedure
  """
  @spec call(CurrentUserState.t, IncomeMessage.t) :: none
  def call(%CurrentUserState{is_signed_in: false}, %IncomeMessage{type: message_type} = income_message) when message_type != :sign_in do
    channel_identifier = IncomeMessage.channel(income_message)
    API.send_message("Looks like you are not signed in... Please sign in first to start your training! :-)", channel_identifier) 
  end
  def call(%CurrentUserState{is_signed_in: false}, %IncomeMessage{type: :sign_in} = income_message) do
    channel_identifier = IncomeMessage.channel(income_message)
    operation_result = SlackBot.Core.Operations.SignIn.call(income_message)  
    case operation_result do
      :ok ->
        API.send_message("Looks good, man! You now is signed in! Good luck :-)", channel_identifier)
      {:error, reason} ->
        reason
        |> message_for_reason
        |> API.send_message(channel_identifier)
    end
  end

  defp message_for_reason(:invalid_message), do: "Hey, man! I think you asked me something wrong... Please, try again."
  defp message_for_reason(:invalid_credentials), do: "Credentials which were provided by you aren't correct!"
end
