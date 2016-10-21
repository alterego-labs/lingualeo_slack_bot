defmodule SlackBot.SlackRtm do
  use Slack

  alias SlackBot.Core.{IncomeMessage, CurrentUserState}
  alias SlackBot.Resolver

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end

  def handle_message(message = %{type: "message", reply_to: nil}, _slack) do
    IO.puts "Received a message: #{message.text}"
  end
  def handle_message(message = %{type: "message"}, slack) do
    IO.puts "Received a message: #{message.text}"
    income_message = IncomeMessage.build(message, slack)
    sender = income_message |> IncomeMessage.sender
    user_state = CurrentUserState.build(sender.name)
    Resolver.call(user_state, income_message)
  end
  def handle_message(_, _), do: :ok

  def handle_info({:message, text, channel}, slack) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok}
  end
  def handle_info(_, _), do: :ok
end
