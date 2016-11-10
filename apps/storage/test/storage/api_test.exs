defmodule Storage.APITest do
  use TestCaseWithDbSandbox

  alias Storage.API
  alias Storage.DB.{User, Word, Repo}

  test "user_by_login_first_or_create when a user with a given already exists just returns it" do
    user = create(:user)
    fetched_user = API.user_by_login_first_or_create(user.login)
    assert %User{} = fetched_user
    assert user.id == fetched_user.id
  end

  test "random_word_for returns a random word which user owns" do
    user = create(:user) |> with_word |> with_word
    random_word = API.random_word_for(user.login)
    assert %Word{} = random_word
  end

  test "train_word marks a passed word as for training" do
    user = create(:user)
    word = create(:word, user: user)
    {:ok} = API.train_word(word)
    user = Repo.preload(user, :word_trainings, [force: true])
    assert Enum.count(user.word_trainings) == 1
  end
end
