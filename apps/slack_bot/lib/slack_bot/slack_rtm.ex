defmodule SlackBot.SlackRtm do
  use Slack

  alias SlackBot.Core.RawIncomeMessage

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end

  def handle_message(message = %{type: "message", user: from_user_id, text: message_text}, slack = %{users: slack_users}) do
    raw_message = %RawIncomeMessage{message: message, slack: slack}
    sender = raw_message |> RawIncomeMessage.sender 
    {:ok, sender_name} = sender |> Map.fetch(:name)
    message_text = raw_message |> RawIncomeMessage.text
    channel_name = raw_message |> RawIncomeMessage.channel
    send_message("I've got a message from #{sender_name}: '#{message_text}'...", channel_name, slack)
  end
  def handle_message(_, _), do: :ok

  def handle_info({:message, text, channel}, slack) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok}
  end
  def handle_info(_, _), do: :ok
end
