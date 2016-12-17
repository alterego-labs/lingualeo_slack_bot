defmodule Storage.DB.Word do
  @moduledoc """
  Represents a model for Word object.
  """

  use Ecto.Schema
  import Ecto.Query

  @type external_id :: String.t | integer

  schema "words" do
    field :external_id, :string
    field :value, :string
    field :translation, :string
    field :transcription, :string
    field :sound_url, :string
    field :pic_url, :string

    belongs_to :user, Storage.DB.User, foreign_key: :user_id
    has_many :word_trainings, Storage.DB.WordTraining, foreign_key: :word_id

    timestamps
  end

  @doc """
  Scope to filter words for a specific user
  """
  @spec for_user(Ecto.Queryable.t, User.t) :: Ecto.Queryable.t
  def for_user(query, user) do
    from w in query,
    where: w.user_id == ^user.id
  end

  @doc """
  Scope to filter words by a given `external_id`
  """
  @spec with_external_id(Ecto.Queryable.t, external_id) :: Ecto.Queryable.t
  def with_external_id(query, external_id) when is_bitstring(external_id) do
    do_with_external_id(query, external_id)
  end
  def with_external_id(query, external_id) when is_number(external_id) do
    do_with_external_id(query, to_string(external_id))
  end

  defp do_with_external_id(query, external_id) do
    from w in query,
    where: w.external_id == ^external_id
  end
end
