defmodule SlackBot.Core.ResponseMessageBuilder do
  @moduledoc """
  Provides response messages.
  
  The message depends on a reason. For example, when user is already signed in but he send a sign in message.
  There are a lot of reasons and you can found them in the source code. Basically this module is used
  by `SlackBot.Resolver` to construct responses.

  Response messages can contain some dynamic parts. That's why interpolations are supported.

  ## Example

  ```elixir
  message_for_reason(:password_is_too_short, [count: 10])
  # => Password which you provided is too short! Minimum length is 10 characters!
  ```
  """
  @messages  %{
    you_are_a_guest: "Looks like you are not signed in... Please sign in first to start your training! :-)",
    signed_in_successfully: "Looks good, man! You now is signed in! Good luck :-)",
    invalid_message: "Hey, man! I think you asked me something wrong... Please, try again.",
    invalid_credentials: "Credentials which were provided by you aren't correct!",
    already_in_training: "Hm... It's likely you are already in training mode...",
    no_words_for_training: "Unfortunately, you do not have some words for training :-(",
    take_a_word_for_training: "Okay, cowboy, that is your word for training: `%{word}`",
    updated_dictionary_successfuly: "Your dictionary has been updated successfuly!",
    you_are_no_longer_signed_in: "Looks like you are no longer signed in... Please make sign in procedure again!",
    unexpected_error: "Some unexpected error was occured. Please try again!",
    not_in_training: "Hm... Looks like you provide an answer, but you aren't in training mode. So start it first!",
    under_construction: "Man, you've been catched into some case logic which is not implemented yet. Sorry :-)"
  }
  
  @doc """
  Constructs a final message for a reason.

  If a message pattern has interpolations you can pass a values as the second argument.
  """
  @spec message_for_reason(atom, Keyword.t) :: String.t
  def message_for_reason(reason, opts \\ [])

  for {reason, message} <- @messages do
    def message_for_reason(unquote(reason), opts) do
      interpolate(unquote(message), opts)
    end
  end

  def message_for_reason(_reason, _opts), do: "Something strange was happened on the server... Please, try again later!"

  defp interpolate(string, []), do: string
  defp interpolate(string, [{name, value} | rest]) do
    n = Atom.to_string(name)
    msg = String.replace(string, "%{#{n}}", to_string(value))
    interpolate(msg, rest)
  end
end
