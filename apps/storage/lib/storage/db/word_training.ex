defmodule Storage.DB.WordTraining do
  @moduledoc """
  Represents a model for Word Training object.
  """

  use Ecto.Schema
  import Ecto.Query

  alias Storage.DB.{User}

  schema "word_trainings" do
    field :status, :string
    field :attempts_to_success, :integer

    belongs_to :user, Storage.DB.User, foreign_key: :user_id
    belongs_to :word, Storage.DB.Word, foreign_key: :word_id
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
  Scope to filter word trinings by *in_progress* status
  """
  @spec for_user(Ecto.Queryable.t) :: Ecto.Queryable.t
  def with_in_progress_status(query) do
    from wt in query,
    where: wt.status == "in_progress"
  end
end
