defmodule SlackBot.Core.Operations.RequestWord do
  @moduledoc """
  Requests new word for training
  """

  alias SlackBot.Core.{IncomeMessage}

  @doc """
  Calls request word operation
  """
  @spec call(IncomeMessage.t) :: {:ok, String.t} | {:error, :no_words_for_training}
  def call(%IncomeMessage{} = income_message) do
    user_login = income_message |> IncomeMessage.sender_name
    if has_words_for_training?(user_login) do
      word_for_training = choose_next_word_for_training(user_login)
      {:ok, word_for_training}
    else
      {:error, :no_words_for_training}
    end
  end

  defp has_words_for_training?(user_login) do
    Storage.API.user_has_words_for_training?(user_login)
  end

  defp choose_next_word_for_training(user_login) do
    word = Storage.API.random_word_for(user_login)
    Storage.API.train_word(word)
    word.value
  end
end
