defmodule Storage.APITest do
  use TestCaseWithDbSandbox

  alias Storage.API
  alias Storage.DB.{User, Word, Repo, WordTraining}

  test "user_by_login_first_or_create when a user with a given already exists just returns it" do
    user = create(:user)
    fetched_user = API.user_by_login_first_or_create(user.login)
    assert %User{} = fetched_user
    assert user.id == fetched_user.id
  end

  test "random_word_for returns a random word which user owns" do
    user = :user |> create |> with_word |> with_word
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

  test "get_training_word returns proper tuple if there is no training word" do
    user = create(:user)
    assert {:error, :no_words_in_training} = API.get_training_word(user.login)
  end

  test "get_training_word returns proper tuple with word if there is a training word" do
    user = create(:user)
    word = create(:word, user: user)
    word_training = create(:word_training_in_progress, word: word, user: user)
    {:ok, %Word{} = result_word} = API.get_training_word(user.login)
    assert result_word.id == word.id
  end

  test "mark_training_success returns proper tuple when the training for the given word exists" do
    user = create(:user)
    word = create(:word, user: user)
    word_training = create(:word_training_in_progress, word: word, user: user)
    assert :ok = API.mark_training_success(user.login, word.id)
    wt = Repo.get(WordTraining, word_training.id)
    assert wt.status == "completed"
  end

  test "mark_training_success returns proper error tuple when there is no training for the given word" do
    user = create(:user)
    word = create(:word, user: user)
    assert {:error, :no_words_in_training} = API.mark_training_success(user.login, word.id)
  end

  test "inc_training_attempts returns proper tuple when the training for the given word exists" do
    user = create(:user)
    word = create(:word, user: user)
    word_training = create(:word_training_in_progress, word: word, user: user)
    assert :ok = API.inc_training_attempts(user.login, word.id)
    wt = Repo.get(WordTraining, word_training.id)
    assert wt.attempts_to_success == 1
  end

  test "inc_training_attempts returns proper error tuple when there is no training for the given word" do
    user = create(:user)
    word = create(:word, user: user)
    assert {:error, :no_words_in_training} = API.inc_training_attempts(user.login, word.id)
  end
end
