defmodule SlackBot.Core.IncomeMessage do
  @moduledoc """
  Encapsulates information which is received via RTM
  """

  defstruct [:message, :slack, :type]

  @type t :: %__MODULE__{}

  @doc """
  Builds an income message struct using income information about received message and slack
  general information.
  """
  @spec build(Map.t, Map.t) :: __MODULE__.t
  def build(%{text: text} = message, slack) do
    type = detect_type(text)
    %__MODULE__{
      message: message,
      slack: slack,
      type: type
    }
  end

  @doc """
  Retrieves a list of all users in a current team

  Returns a map where key is a user ID and a value is a hash with attributes. The list of all
  available attributes you can see in the example for `SlackBot.Core.IncomeMessage.sender/1`.
  """
  @spec slack_users(SlackBot.Core.IncomeMessage.t) :: Map.t
  def slack_users(%__MODULE__{slack: slack}) do
    {:ok, users} = slack |> Map.fetch(:users)
    users
  end

  @doc """
  Retrieves information about message sender

  ### Example

  ```elixir
    raw_message = ...
    SlackBot.Core.IncomeMessage.sender(raw_message)
    # => %{color: "e7392d", deleted: false, id: "kahdalkddas",
    # is_admin: false, is_bot: false, is_owner: false, is_primary_owner: false,
    # is_restricted: false, is_ultra_restricted: false, name: "sergio1990",
    # presence: "active",
    # profile: %{avatar_hash: "asjdkasdjas", email: "some@gmail.com",
    #   fields: %{aldjlasjdasasd: %{alt: "", value: "some"}},
    #   first_name: "Sergey",
    #   image_192: "...",
    #   image_24: "...",
    #   image_32: "...",
    #   image_48: "...",
    #   image_512: "...",
    #   image_72: "...",
    #   last_name: "Gernyak", real_name: "Sergey Gernyak",
    #   real_name_normalized: "Sergey Gernyak", skype: "some",
    #   title: "Software engineer"}, real_name: "Sergey Gernyak", status: nil,
    # team_id: "JASDASJD", tz: "EET", tz_label: "", tz_offset: 10800}
   ```
  """
  @spec sender(SlackBot.Core.IncomeMessage.t) :: Map.t
  def sender(%__MODULE__{message: message} = raw_message) do
    {:ok, sender_id} = message |> Map.fetch(:user)
    {:ok, attributes} = raw_message |> slack_users |> Map.fetch(sender_id)
    attributes
  end

  @doc """
  Retrieves an original message text
  """
  @spec text(SlackBot.Code.IncomeMessage.t) :: String.t
  def text(%__MODULE__{message: message}) do
    {:ok, message_text} = message |> Map.fetch(:text)  
    message_text
  end

  @doc """
  Retrieves a channel ID from which message has been sent
  """
  @spec channel(SlackBot.Core.IncomeMessage.t) :: String.t
  def channel(%__MODULE__{message: message}) do
    {:ok, channel_id} = message |> Map.fetch(:channel)
    channel_id
  end

  defp detect_type(message_text) do
    cond do
      Regex.match?(~r/^Sign in me by \w+@\w+ and .+$/, message_text) ->
        :sign_in
      Regex.match?(~r/^Give me a word$/, message_text) ->
        :request_word
      Regex.match?(~r/^.+$/, message_text) ->
        :answer
      true ->
        :unknown
    end
  end
end
