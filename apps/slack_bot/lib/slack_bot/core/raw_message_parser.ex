defmodule SlackBot.Core.RawMessageParser do
  @moduledoc """
  Parses raw income message and detects its type.

  Type can be:
  - `:sign_in`
  - `:request_word`
  - `:answer`
  - `:unknown`
  """

  alias SlackBot.Core.{RawIncomeMessage, Message}

  @doc """
  Calls parser
  """
  @spec call(RawIncomeMessage.t) :: Message.t
  def call(%RawIncomeMessage{} = raw_message) do
    message_text = RawIncomeMessage.text(raw_message)
    type = detect_type(message_text)
    %Message{type: type, raw_message: raw_message}
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
