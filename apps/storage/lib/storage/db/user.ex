defmodule Storage.DB.User do
  @moduledoc """
  Represents a model for User object.
  """

  use Ecto.Schema
  import Ecto.Query

  alias Storage.DB.{Repo, WordTraining, Word}

  @type t :: %__MODULE__{}

  schema "users" do
    field :login, :string
    field :cookies, :string
    field :response_hash, :string

    has_many :words, Storage.DB.Word, foreign_key: :user_id
    has_many :word_trainings, Storage.DB.WordTraining, foreign_key: :user_id

    timestamps
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

  @doc """
  Specifies if user is in training or not
  """
  @spec is_in_training?(__MODULE__.t) :: boolean
  def is_in_training?(%__MODULE__{} = user) do
    count = WordTraining
            |> WordTraining.for_user(user)
            |> WordTraining.with_in_progress_status
            |> Repo.all
            |> Enum.count
    count > 0
  end

  @doc """
  Specifies if user has available words for training
  """
  def has_words_for_training?(%__MODULE__{} = user) do
    user = Repo.preload(user, :words, [force: true])
    count = user.words |> Enum.count
    count > 0
  end

  @doc """
  Parses cookie string into a list of entries.
  """
  @spec parse_cookie(String.t) :: map | list
  def parse_cookie(cookie) when is_bitstring(cookie) do
    {:ok, response_hash} = JSX.decode(cookie, [{:labels, :atom}])
    response_hash
  end
  def parse_cookie(nil), do: []
end
