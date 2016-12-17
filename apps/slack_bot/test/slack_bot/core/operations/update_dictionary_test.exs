defmodule SlackBot.Core.Operations.UpdateDictionaryTest do
  use ExUnit.Case, async: true

  import Mock

  alias SlackBot.Core.Operations.{UpdateDictionary}
  alias Storage.DB.{User, Word}
  alias LingualeoGateway.Core.UserDict

  setup_all do
    user = %User{cookies: "['a']"}
    raw_word = TestHelper.valid_raw_word
    income_message = TestHelper.valid_income_message
    {:ok, %{user: user, raw_word: raw_word, income_message: income_message}}
  end

  test "returns :ok if all were completed successfully", %{user: user, raw_word: raw_word, income_message: income_message} do
    with_mocks([
      {Storage.API,
       [],
       [user_by_login: fn(_login) -> user end,
        add_word: fn(_login, %Word{} = _word) -> :ok end],},
      {LingualeoGateway.API,
       [],
       [get_userdict: fn(_cookies, _offset) -> {:ok, %UserDict{has_more: false, words: [raw_word]}} end]}
    ]) do
      assert :ok = UpdateDictionary.call(income_message)
    end
  end
end
