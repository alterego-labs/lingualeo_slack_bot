defmodule SlackBot.Operations.UpdateDictionary do
  @moduledoc """
  Makes update dictionary operation to the Lingualeo API
  """

  alias SlackBot.Core.{IncomeMessage}
  alias Storage.DB.{User, Repo, Word, WordTraining}
  alias LingualeoGateway.Core.UserDict

  @doc """
  Calls sign in operation
  """
  @spec call(IncomeMessage.t) :: :ok | {:error, :you_are_no_longer_signed_in}
  def call(%IncomeMessage{} = income_message) do
    user_login = IncomeMessage.sender_name(income_message)
    case fetch_words(user_login) do
      {:ok, words} ->
        save_words(user_login, words)
        :ok
      {:error, reason} -> decide_about_return_reason(reason)
    end
  end

  defp fetch_words(user_login) do
    user = Storage.API.user_by_login(user_login)
    cookie = User.parse_cookie(user.cookie)
    do_fetch_words(cookie, 400, [])
  end

  defp do_fetch_words(cookie, offset, words) do
    case LingualeoGateway.API.get_userdict(cookie, offset) do
      {:ok, %UserDict{} = user_dict} ->
        case user_dict.has_more do
          true -> do_fetch_words(cookie, offset + 400, words ++ user_dict.words)
          false -> {:ok, words}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  defp save_words(user_login, words) do
    words
    |> Enum.map(&make_word_record_from_map(&1))
    |> Enum.each(&Storage.API.add_word(user_login, &1))
  end

  defp decide_about_return_reason(:unauthorized), do: :you_are_no_longer_signed_in
  defp decide_about_return_reason(:unexpected_error), do: :unexpected_error

  defp make_word_record_from_map(word_map) do
    %Word{
      external_id:   Map.get(word_map, :word_id),
      value:         Map.get(word_map, :word_value),
      translation:   Map.get(word_map, :translation),
      transcription: Map.get(word_map, :transcription),
      sound_url:     Map.get(word_map, :sound_url),
      pic_url:       Map.get(word_map, :pic_url),
    }
  end
end
