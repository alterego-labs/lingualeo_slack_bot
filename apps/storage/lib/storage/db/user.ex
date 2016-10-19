defmodule Storage.DB.User do
  @moduledoc """
  Represents a model for User object.
  """

  use Ecto.Schema

  schema "users" do
    field :login, :string
    field :cookies, :text
    field :response_hash, :text

    has_many :words, Storage.DB.Word, foreign_key: :user_id
    has_many :word_trainings, Storage.DB.WordTraining, foreign_key: :user_id
  end
end
