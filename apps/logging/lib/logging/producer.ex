defmodule Logging.Producer do
  @moduledoc """
  Makes a module where you use it as a logs producer.

  When you use this module you must to specify a `from_application` parameter. For example:

  ```elixir
  defmodule SlackBot.SlackRtm do
    use Logging.Producer, from_application: :slack_bot
  end
  ```

  Thanks for that you do not need to pass application name explicitly into the each Logging API
  call. So after using `Logging.Producer` you will have 4 additional functions:

    - `logging_debug/1`
    - `logging_info/1`
    - `logging_error/1`
    - `logging_warn/1`
  """

  @levels [:debug, :info, :error, :warn]

  defmacro __using__([from_application: from_application]) do
    @levels |> Enum.map(fn(log_level) ->
      name = String.to_atom "logging_#{log_level}"
      quote do
        def unquote(name)(message) do
          Logging.API.unquote(log_level)(unquote(from_application), message)
        end
      end
    end)
  end
end
