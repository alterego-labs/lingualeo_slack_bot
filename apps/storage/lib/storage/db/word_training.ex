defmodule Storage.DB.WordTraining do
  @moduledoc """
  Represents a model for Word Training object.
  """

  use Ecto.Schema
  import Ecto.Query

  alias Storage.DB.{User, Word, Repo}

  schema "word_trainings" do
    field :status, :string
    field :attempts_to_success, :integer

    belongs_to :user, Storage.DB.User, foreign_key: :user_id
    belongs_to :word, Storage.DB.Word, foreign_key: :word_id

    timestamps
  end

  @doc """
  Scope to filter word trainings for a specific user
  """
  @spec for_user(Ecto.Queryable.t, User.t) :: Ecto.Queryable.t
  def for_user(query, user) do
    from wt in query,
    where: wt.user_id == ^user.id
  end

  @doc """
  Scope to filter word tranings by *in_progress* status
  """
  @spec with_in_progress_status(Ecto.Queryable.t) :: Ecto.Queryable.t
  def with_in_progress_status(query) do
    from wt in query,
    where: wt.status == "in_progress"
  end

  @doc """
  Scope to filter word trainings by *word_id* value
  """
  @spec with_word_id(Ecto.Queryable.t, integer) :: Ecto.Queryable.t
  def with_word_id(query, word_id) do
    from wt in query,
    where: wt.word_id == ^word_id
  end

  @doc """
  Builds new word training struct based on a given word
  """
  @spec build_new_for(Word.t) :: WordTraining.t
  def build_new_for(word) do
    word = Repo.preload(word, :user)
    %__MODULE__{
      status: "in_progress",
      word: word,
      user: word.user
    }
  end
end
