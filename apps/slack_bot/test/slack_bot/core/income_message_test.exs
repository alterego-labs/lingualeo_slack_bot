defmodule SlackBot.Core.IncomeMessageTest do
  use ExUnit.Case, async: true

  alias SlackBot.Core.IncomeMessage

  setup_all do
    raw_message = %SlackBot.Core.IncomeMessage{
      message: %{
        channel: "channel_id",
        team: "team_id",
        text: "hi!",
        ts: "1476706205.000002",
        type: "message",
        user: "user_id"
      },
      slack: %{
        users: %{
          "user_id" => %{
            id: "user_id",
            is_admin: false,
            profile: %{
              email: "some@gmail.com"
            },
            name: "sergeg1990"
          }
        }
      }
    }
    {:ok, %{raw_message: raw_message}}
  end

  test "build initializes new struct with a type" do
    raw_message = IncomeMessage.build(%{text: "Give me a word"}, %{})
    assert %IncomeMessage{} = raw_message
    assert raw_message.type == :request_word
  end

  test "build inits struct with a proper type when income message tells to update dictionary" do
    raw_message = IncomeMessage.build(%{text: "Update dictionary"}, %{})
    assert %IncomeMessage{} = raw_message
    assert raw_message.type == :update_dictionary
  end

  test "build cleans up a message from mailto" do
    income_message = IncomeMessage.build(%{text: "Sign in me by <mailto:sergeg1990@gmail.com|sergeg1990@gmail.com> and somepassword"}, %{})
    text = income_message |> IncomeMessage.text
    assert text == "Sign in me by sergeg1990@gmail.com and somepassword"
  end

  test "slack_users returns list of users", %{raw_message: raw_message} do
    users = IncomeMessage.slack_users(raw_message)
    assert is_map(users)
    assert Map.has_key?(users, "user_id")
  end

  test "sender returns information about message writer", %{raw_message: raw_message} do
    sender = IncomeMessage.sender(raw_message)
    assert is_map(sender)
    assert Map.has_key?(sender, :name)
  end

  test "text returns original message text", %{raw_message: raw_message} do
    message_text = IncomeMessage.text(raw_message)
    assert message_text == "hi!"
  end

  test "channel returns channel id", %{raw_message: raw_message} do
    channel_id = IncomeMessage.channel(raw_message)
    assert channel_id == "channel_id"
  end

  test "sign_in_credentials when type is not sign in returns error" do
    income_message = %IncomeMessage{type: :unknown}
    credentials = income_message |> IncomeMessage.sign_in_credentials
    assert {:error, _} = credentials
  end

  test "sign_in_credentials when type is sign in returns credentials from the message text" do
    income_message = %IncomeMessage{type: :sign_in, message: %{text: "Sign in me by sergeg1990@gmail.com and somepassword"}}
    credentials = income_message |> IncomeMessage.sign_in_credentials
    assert {:ok, %{email: "sergeg1990@gmail.com", password: "somepassword"}} = credentials
  end
end
