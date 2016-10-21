defmodule SlackBot.Resolver do
  @moduledoc """
  Makes decision about what action must be performed based on user state and message information.
  """

  alias SlackBot.Core.{IncomeMessage, CurrentUserState}

  @doc """
  Runs resolving procedure
  """
  @spec call(CurrentUserState.t, IncomeMessage.t) :: none
  def call(%CurrentUserState{is_signed_in: false}, %IncomeMessage{type: message_type} = income_message) when message_type != :sign_in do
    channel_identifier = IncomeMessage.channel(income_message)
    SlackBot.API.send_message("Looks like you are not signed in... Please sign in first to start your training! :-)", channel_identifier) 
  end
end
