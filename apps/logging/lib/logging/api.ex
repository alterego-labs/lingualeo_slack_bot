defmodule Logging.API do
  @moduledoc """
  The API interface of the Logging application
  """

  require Logger

  @type app_name :: atom

  @spec debug(app_name, String.t) :: none
  def debug(from_application, message) do
    call_logger :debug, from_application, message
  end

  @spec info(app_name, String.t) :: none
  def info(from_application, message) do
    # Logger.info(message, app: from_application)
    call_logger :info, from_application, message
  end

  @spec warn(app_name, String.t) :: none
  def warn(from_application, message) do
    call_logger :warn, from_application, message
  end

  @spec error(app_name, String.t) :: none
  def error(from_application, message) do
    call_logger :error, from_application, message
  end

  defp call_logger(level, from_application, message) do
    Logger.log level, message, app: from_application
  end
end
