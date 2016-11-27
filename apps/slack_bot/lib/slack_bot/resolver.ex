defmodule SlackBot.Resolver do
  @moduledoc """
  Makes decision about what action must be performed based on user state and message information.
  """

  alias SlackBot.Core.{IncomeMessage, CurrentUserState, Operations}
  alias SlackBot.API

  import SlackBot.Core.ResponseMessageBuilder

  @doc """
  Runs resolving procedure
  """
  @spec call(CurrentUserState.t, IncomeMessage.t) :: none
  def call(%CurrentUserState{is_signed_in: false}, %IncomeMessage{type: message_type} = income_message) when message_type != :sign_in do
    send_message_back(:you_are_a_guest, income_message)
  end
  def call(%CurrentUserState{is_signed_in: false}, %IncomeMessage{type: :sign_in} = income_message) do
    operation_result = Operations.SignIn.call(income_message)  
    message_reason = case operation_result do
      :ok -> :signed_in_successfully
      {:error, reason} -> reason
    end
    send_message_back(message_reason, income_message)
  end
  def call(%CurrentUserState{is_signed_in: true, is_in_training: false}, %IncomeMessage{type: :sign_in} = income_message) do
    send_message_back(:invalid_message, income_message)
  end
  def call(%CurrentUserState{is_signed_in: true, is_in_training: true}, %IncomeMessage{type: :request_word} = income_message) do
    send_message_back(:already_in_training, income_message)
  end
  def call(%CurrentUserState{is_signed_in: true, is_in_training: true}, %IncomeMessage{type: :update_dictionary} = income_message) do
    send_message_back(:already_in_training, income_message)
  end
  def call(%CurrentUserState{is_signed_in: true, is_in_training: false}, %IncomeMessage{type: :request_word} = income_message) do
    operation_result = Operations.RequestWord.call(income_message)
    message_reason = case operation_result do
      {:ok, word_for_training} -> send_message_back(:take_a_word_for_training, income_message, [word: word_for_training])
      {:error, reason} -> send_message_back(reason, income_message)
    end
  end
  def call(%CurrentUserState{is_signed_in: true, is_in_training: false}, %IncomeMessage{type: :update_dictionary} = income_message) do
    operation_result = Operations.UpdateDictionary.call(income_message)
    send_message_back(:updated_dictionary_successfuly, income_message)
  end

  defp send_message_back(reason, %IncomeMessage{} = income_message, opts \\ []) do
    channel_identifier = IncomeMessage.channel(income_message)
    reason |> message_for_reason(opts) |> API.send_message(channel_identifier)
  end
end
