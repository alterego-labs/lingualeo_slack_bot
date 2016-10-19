defmodule Storage.DB.WordTraining do
  @moduledoc """
  Represents a model for Word Training object.
  """

  use Ecto.Schema

  schema "word_trainings" do
    field :status, :string
    field :attempts_to_success, :integer

    belongs_to :user, Storage.DB.User, foreign_key: :user_id
    belongs_to :word, Storage.DB.Word, foreign_key: :word_id
  end
end
