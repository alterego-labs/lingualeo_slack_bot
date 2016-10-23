defmodule SlackBot.SlackRtm do
  @moduledoc """
  Represents a worker which is connected to Slack RTM
  """

  use Slack
  use Logging.Producer, from_application: :slack_bot

  alias SlackBot.Core.{IncomeMessage, CurrentUserState}
  alias SlackBot.Resolver

  def handle_connect(slack) do
    logging_info("Connected as #{slack.me.name}")
  end

  def handle_message(message = %{type: "message", reply_to: nil}, _slack) do
    logging_info("Received a message: '#{message.text}'")
  end
  def handle_message(message = %{type: "message"}, slack) do
    logging_info("Received a message: '#{message.text}'")
    income_message = IncomeMessage.build(message, slack)
    sender = income_message |> IncomeMessage.sender
    user_state = CurrentUserState.build(sender.name)
    Resolver.call(user_state, income_message)
  end
  def handle_message(_, _), do: :ok

  def handle_info({:message, text, channel}, slack) do
    logging_info("Sending your message, captain: '#{text}'")

    send_message(text, channel, slack)

    {:ok}
  end
  def handle_info(_, _), do: :ok
end
