defmodule SlackBot.Core.RawIncomeMessageTest do
  use ExUnit.Case, async: true

  alias SlackBot.Core.RawIncomeMessage

  setup_all do
    raw_message = %SlackBot.Core.RawIncomeMessage{
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

  test "slack_users returns list of users", %{raw_message: raw_message} do
    users = RawIncomeMessage.slack_users(raw_message)
    assert is_map(users)
    assert Map.has_key?(users, "user_id")
  end

  test "sender returns information about message writer", %{raw_message: raw_message} do
    sender = RawIncomeMessage.sender(raw_message)
    assert is_map(sender)
    assert Map.has_key?(sender, :name)
  end

  test "text returns original message text", %{raw_message: raw_message} do
    message_text = RawIncomeMessage.text(raw_message)
    assert message_text == "hi!"
  end

  test "channel returns channel id", %{raw_message: raw_message} do
    channel_id = RawIncomeMessage.channel(raw_message)
    assert channel_id == "channel_id"
  end
end
