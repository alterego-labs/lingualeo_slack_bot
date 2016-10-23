defmodule Logging.Producer do
  @moduledoc """
  Makes a module where you use it as a logs producer.

  When you use this module you can specify a `from_application` parameter. For example:

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

  When you do not specify `from_application` option a default application name will be used. It is
  evaluated as application for a module in which you use `Logging.Producer` module.
  """

  @levels [:debug, :info, :error, :warn]

  defmacro __using__(opts \\ []) do
    @levels |> Enum.map(fn(log_level) ->
      name = String.to_atom "logging_#{log_level}"
      quote do
        def unquote(name)(message) do
          default_app_name = Application.get_application(__MODULE__)
          app_name = unquote(opts) |> Keyword.get(:from_application, default_app_name)
          Logging.API.unquote(log_level)(app_name, message)
        end
      end
    end)
  end
end
