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
end
