defmodule Storage.API do
  @moduledoc """
  The API interface of the application.
  """

  @type user_login :: String.t

  alias Storage.DB.{User, Repo, Word, WordTraining}

  @doc """
  Checks is an user with a given login signed in or not.
  """
  @spec user_signed_in?(user_login) :: boolean
  def user_signed_in?(user_login) do
    user_login
    |> user_by_login
    |> resolve_user_signed_in
  end

  @doc """
  Checks if an user with a given login exists or not.
  """
  @spec user_exists?(user_login) :: boolean
  def user_exists?(user_login) do
    user_login
    |> user_by_login
    |> not_nil?
  end

  @doc """
  Fetches user by login.
  """
  @spec user_by_login(user_login) :: %User{} | nil
  def user_by_login(user_login) do
    user_login
    |> User.fetch_by_login
  end

  @doc """
  Fetches user by login and if such one exists just returns it. Otherwise a new user will be created.
  """
  @spec user_by_login_first_or_create(user_login) :: User.t
  def user_by_login_first_or_create(user_login) do
    case user_by_login(user_login) do
      %User{} = user -> user
      nil ->
        {:ok, user} = %User{login: user_login} |> Repo.insert
        user
    end
  end

  @doc """
  Updates an user with a given attributes list.

  ## Examples

  Update attributes of already existed user:

  ```elixir
  user
  |> Storage.API.user_update(%{cookies: "[...]", response_hash: "{...}"})
  ```

  Makes user unauthorized

  ```elixir
  user
  |> Storage.API.user_update(%{cookies: "", response_hash: ""})
  ```
  """
  @spec user_update(User.t, Map.t) :: none
  def user_update(%User{} = user, attributes \\ %{}) do
    user
    |> Ecto.Changeset.change(attributes)
    |> Repo.update
  end

  @doc """
  Checks if user with a given login is in training already.
  """
  @spec user_is_in_training?(user_login) :: boolean
  def user_is_in_training?(user_login) do
    user_login
    |> user_by_login
    |> resolve_user_is_in_training
  end

  @doc """
  Checks if an user has available words for training.
  """
  @spec user_has_words_for_training?(user_login) :: boolean
  def user_has_words_for_training?(user_login) do
    user_login
    |> user_by_login
    |> User.has_words_for_training?
  end

  @doc """
  Fetches a random word for user.
  """
  @spec random_word_for(user_login) :: Word.t
  def random_word_for(user_login) do
    user = user_login |> user_by_login |> Repo.preload(:words, [force: true])
    user.words |> Enum.random
  end

  @doc """
  Marks a given word for training.
  """
  @spec train_word(Word.t) :: {:ok | :error}
  def train_word(word) do
    word_training = WordTraining.build_new_for(word)
    case Repo.insert(word_training) do
      {:ok, _struct} -> {:ok}
      {:error, _changeset} -> {:error}
    end
  end

  @doc """
  Adds a word to an user's dictionary.

  You must prepare a `Storage.DB.Word` struct manually to be able to perform this action.

  _Notice:_ each word has uniq `external_id` identifier. If word with the same `external_id`
  for a given user is already exists, the new one won't be added.
  """
  @spec add_word(user_login, Word.t) :: none
  def add_word(user_login, %Word{} = word) do
    user = user_by_login(user_login)
    case has_word_with_external_id?(user, word.external_id) do
      true -> {:error, :already_exists}
      false -> create_new_word(user, word)
    end
  end

  @doc """
  Provides information about user's training word.
  """
  @spec get_training_word(user_login) :: {:ok, Word.t} | {:error, :no_words_in_training}
  def get_training_word(user_login) do
    user = user_by_login(user_login)
    case fetch_word_training(user) do
      %WordTraining{} = word_training ->
        word_training = Repo.preload(word_training, :word, [force: true])
        {:ok, word_training.word}
      nil -> {:error, :no_words_in_training}
    end
  end

  @doc """
  Marks a training for the given word as successful.
  """
  @spec mark_training_success(user_login, integer) :: :ok | {:error, :no_words_in_training}
  def mark_training_success(user_login, word_id) do
    user = user_by_login(user_login)
    # TODO: What about if there are several trainings for the single word?     
    word_training = WordTraining
                    |> WordTraining.for_user(user)
                    |> WordTraining.with_word_id(word_id)
                    |> WordTraining.with_in_progress_status
                    |> Repo.one
    case word_training do
      %WordTraining{} = word_training ->
        word_training = Ecto.Changeset.change word_training, status: "completed"
        Repo.update(word_training)
        :ok
      nil -> {:error, :no_words_in_training}
    end
  end

  @doc """
  Increments a number of attempts which were needed to complete a training for a given word
  """
  @spec inc_training_attempts(user_login, integer) :: :ok | {:error, :no_words_in_training}
  def inc_training_attempts(user_login, word_id) do
    user = user_by_login(user_login)
    # TODO: What about if there are several trainings for the single word?     
    word_training = WordTraining
                    |> WordTraining.for_user(user)
                    |> WordTraining.with_word_id(word_id)
                    |> WordTraining.with_in_progress_status
                    |> Repo.one
    case word_training do
      %WordTraining{} = word_training ->
        new_attempts_count = word_training.attempts_to_success + 1
        word_training = Ecto.Changeset.change word_training, attempts_to_success: new_attempts_count
        Repo.update(word_training)
        :ok
      nil -> {:error, :no_words_in_training}
    end
  end

  defp has_word_with_external_id?(user, external_id) do
    words = Word
            |> Word.for_user(user)
            |> Word.with_external_id(external_id)
            |> Repo.all
    Enum.count(words) > 0
  end

  defp create_new_word(%User{} = user, %Word{} = word) do
    word = %{word | user_id: user.id}
    case Repo.insert(word) do
      {:ok, _struct} -> {:ok}
      {:error, _changeset} -> {:error, :insert_failed}
    end
  end

  defp resolve_user_signed_in(nil = user), do: false
  defp resolve_user_signed_in(user) do
    User.signed_in?(user)
  end

  defp resolve_user_is_in_training(nil = user), do: false
  defp resolve_user_is_in_training(user) do
    User.is_in_training?(user)
  end

  defp not_nil?(value) do
    !is_nil(value)
  end

  defp fetch_word_training(user) do
    WordTraining
    |> WordTraining.for_user(user)
    |> WordTraining.with_in_progress_status
    |> Repo.one
  end
end
