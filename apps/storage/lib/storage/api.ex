defmodule Storage.API do
  @moduledoc """
  The API interface of the application.
  """

  @type user_login :: String.t

  alias Storage.DB.{User}

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

  defp resolve_user_signed_in(nil = user), do: false
  defp resolve_user_signed_in(user) do
    User.signed_in?(user)
  end

  defp not_nil?(value) do
    !is_nil(value)
  end
end
