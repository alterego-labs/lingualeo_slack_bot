defmodule Storage.DB.Word do
  @moduledoc """
  Represents a model for Word object.
  """

  use Ecto.Schema

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
end
