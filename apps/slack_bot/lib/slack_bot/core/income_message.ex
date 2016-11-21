defmodule SlackBot.Core.IncomeMessage do
  @moduledoc """
  Encapsulates information which is received via RTM
  """

  defstruct [:message, :slack, :type]

  @type t :: %__MODULE__{}
  @type reason :: String.t

  @sign_in_type_regexp ~r/^Sign in me by (?<email>\w+@[\w\.\-]+) and (?<password>.+)$/

  @doc """
  Builds an income message struct using income information about received message and slack
  general information.
  """
  @spec build(Map.t, Map.t) :: __MODULE__.t
  def build(%{text: text} = message, slack) do
    clear_text = cleanup_text(text)
    type = detect_type(clear_text)
    new_message = Map.put(message, :text, clear_text)
    %__MODULE__{
      message: new_message,
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
    income_message = ...
    SlackBot.Core.IncomeMessage.sender(income_message)
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
  def sender(%__MODULE__{message: message} = income_message) do
    {:ok, sender_id} = message |> Map.fetch(:user)
    {:ok, attributes} = income_message |> slack_users |> Map.fetch(sender_id)
    attributes
  end

  @doc """
  Fetches a sender's name
  """
  @spec sender_name(SlackBot.Core.IncomeMessage.t) :: String.t
  def sender_name(%__MODULE__{} = income_message) do
    sender = income_message |> sender
    sender.name
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

  @doc """
  Fetches from a message text credentials for sign in procedure
  """
  @spec sign_in_credentials(SlackBot.Core.IncomeMessage.t) :: {:ok, %{email: String.t, password: String.t}} | {:error, reason}
  def sign_in_credentials(%__MODULE__{type: type}) when type != :sign_in, do: {:error, "You tried to get credentials from the not sign in message!"}
  def sign_in_credentials(%__MODULE__{} = income_message) do
    message_text = income_message |> text
    captures = @sign_in_type_regexp
                |> Regex.named_captures(message_text)
                |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
    {:ok, captures}
  end

  defp detect_type(message_text) do
    cond do
      Regex.match?(@sign_in_type_regexp, message_text) -> :sign_in
      Regex.match?(~r/^Give me a word$/, message_text) -> :request_word
      Regex.match?(~r/^Update dictionary$/, message_text) -> :update_dictionary
      Regex.match?(~r/^.+$/, message_text) -> :answer
      true -> :unknown
    end
  end

  defp cleanup_text(message_text) do
    Regex.replace(~r/<mailto:.*\|(\w+@[\w\.\-]+)>/, message_text, "\\1")
  end
end
