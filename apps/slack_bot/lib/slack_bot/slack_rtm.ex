defmodule SlackBot.SlackRtm do
  use Slack

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end

  def handle_message(message = %{type: "message", user: from_user_id, text: message_text}, slack = %{users: slack_users}) do
    IO.inspect message
    IO.inspect slack
    {:ok, from_user} = slack_users |> Map.fetch(from_user_id)
    {:ok, from_user_name} = from_user |> Map.fetch(:name)
    send_message("I've got a message from #{from_user_name}: '#{message_text}'...", message.channel, slack)
  end
  def handle_message(_, _), do: :ok

  def handle_info({:message, text, channel}, slack) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok}
  end
  def handle_info(_, _), do: :ok
end
