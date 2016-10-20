defmodule Storage.DB.User do
  @moduledoc """
  Represents a model for User object.
  """

  use Ecto.Schema
  import Ecto.Query

  alias Storage.DB.Repo

  @type t :: %__MODULE__{}

  schema "users" do
    field :login, :string
    field :cookies, :string
    field :response_hash, :string

    has_many :words, Storage.DB.Word, foreign_key: :user_id
    has_many :word_trainings, Storage.DB.WordTraining, foreign_key: :user_id
  end

  @doc """
  Fetches user by login
  """
  @spec fetch_by_login(String.t | nil) :: %__MODULE__{} | nil
  def fetch_by_login(nil = user_login), do: nil
  def fetch_by_login(user_login) do
    query = from u in __MODULE__, where: u.login == ^user_login
    Repo.one(query)
  end

  @doc """
  Specifies if user signed in or not.

  To check it the field cookies is used.
  """
  @spec signed_in?(__MODULE__.t) :: boolean
  def signed_in?(%__MODULE__{cookies: cookies} = user) do
    !is_nil(cookies) && cookies != ""
  end
end
