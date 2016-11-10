defmodule SlackBot.Core.CurrentUserState do
  @moduledoc """
  Encapsulates a current user state.

  Current user is the one which has posted a message.
  """

  defstruct is_signed_in: false, is_in_training: false, user_login: nil

  @type t :: %__MODULE__{}

  @doc """
  Builds state of a user with a given login
  """
  @spec build(String.t) :: __MODULE__.t 
  def build(user_login) do
    %__MODULE__{
      is_signed_in: detect_signed_in_status(user_login),
      is_in_training: detect_training_status(user_login),
      user_login: user_login
    }
  end

  defp detect_signed_in_status(user_login) do
    Storage.API.user_signed_in?(user_login)
  end

  defp detect_training_status(user_login) do
    Storage.API.user_is_in_training?(user_login)
  end
end
