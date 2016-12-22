defmodule SlackBot.Core.Operations.ProcessAnswer do
  alias SlackBot.Core.{IncomeMessage}
  alias Storage.DB.{User, Word, WordTraining}

  @doc """
  Calls proccessing answer operation
  """
  @spec call(IncomeMessage.t) :: :ok | {:error, :invalid_answer} | {:error, :no_words_for_training}
  def call(%IncomeMessage{} = income_message) do
    answer_text = IncomeMessage.text(income_message)
    user_login = IncomeMessage.sender_name(income_message)
    result = user_login
              |> Storage.API.get_training_word
              |> resolve_by_training_word(answer_text, user_login)
  end

  defp resolve_by_training_word({:error, :no_words_for_training}, _text, _login) do
    {:error, :no_words_for_training} 
  end
  defp resolve_by_training_word({:ok, %Word{} = word}, answer_text, user_login) do
    Storage.API.inc_training_attempts(user_login, word.id)
    case word.translation == answer_text do
      true ->
        Storage.API.mark_training_success(user_login, word.id)
        :ok
      false ->
        {:error, :invalid_answer}
    end
  end
end
