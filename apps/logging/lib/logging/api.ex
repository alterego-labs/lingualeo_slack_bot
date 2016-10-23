defmodule Logging.API do
  @moduledoc """
  The API interface of the Logging application.

  The main exposed functions are:

    - `debug/2`
    - `info/2`
    - `error/2`
    - `warn/2`

  All of them expects two parameters:

    1. A application name which produces a log
    2. A message
  """

  require Logger

  @type app_name :: atom

  @doc """
  Writes debug log message
  """
  @spec debug(app_name, String.t) :: none
  def debug(from_application, message) do
    call_logger :debug, from_application, message
  end

  @doc """
  Writes info log message
  """
  @spec info(app_name, String.t) :: none
  def info(from_application, message) do
    call_logger :info, from_application, message
  end

  @doc """
  Writes warn log message
  """
  @spec warn(app_name, String.t) :: none
  def warn(from_application, message) do
    call_logger :warn, from_application, message
  end

  @doc """
  Writes error log message
  """
  @spec error(app_name, String.t) :: none
  def error(from_application, message) do
    call_logger :error, from_application, message
  end

  defp call_logger(level, from_application, message) do
    Logger.log level, message, app: from_application
  end
end
