defmodule Storage.API do
  @moduledoc """
  The API interface of the application.
  """

  @type user_login :: String.t

  alias Storage.DB.{User, Repo}

  @doc """
  Checks is an user with a given login signed in or not
  """
  @spec user_signed_in?(user_login) :: boolean
  def user_signed_in?(user_login) do
    user_login
    |> user_by_login
    |> resolve_user_signed_in
  end

  @doc """
  Checks if an user with a given login exists or not
  """
  @spec user_exists?(user_login) :: boolean
  def user_exists?(user_login) do
    user_login
    |> user_by_login
    |> not_nil?
  end

  @doc """
  Fetches user by login
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
  Updates an user with a given attributes list
  """
  @spec user_update(User.t, Map.t) :: none
  def user_update(%User{} = user, attributes \\ %{}) do
    user
    |> Ecto.Changeset.change(attributes)
    |> Repo.update
  end

  @doc """
  Checks if user with a given login is in training already
  """
  @spec user_is_in_training?(user_login) :: boolean
  def user_is_in_training?(user_login) do
    user_login
    |> user_by_login
    |> resolve_user_is_in_training
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
end
