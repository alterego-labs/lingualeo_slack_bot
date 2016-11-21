defmodule LingualeoGateway.Core.Utils do
  @moduledoc """
  Provides a bunch of common helper functions
  """

  @doc """
  Interpolates a string with a variables inside

  Variable is represented as `%{variable_name}`.

  ## Example

  ```elixir
  interpolate_string("Hello, %{user_name}", [user_name: 'Sergio'])
  # => Hello, Sergio
  ```
  """
  def interpolate_string(string, []), do: string
  def interpolate_string(string, [{name, value} | rest]) do
    n = Atom.to_string(name)
    msg = String.replace(string, "%{#{n}}", to_string(value))
    interpolate_string(msg, rest)
  end
end
