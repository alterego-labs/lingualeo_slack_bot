defmodule SlackBot.Core.Message do
  @doc """
  Represents a classified income message
  """

  defstruct [:type, :raw_message]

  @type t :: __MODULE__
end
