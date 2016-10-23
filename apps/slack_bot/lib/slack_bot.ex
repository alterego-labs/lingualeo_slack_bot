defmodule SlackBot do
  @moduledoc """
  SlackBot application's main module.

  Is represented as top level supervisor.
  """

  use Application

  @doc """
  Starts an application.
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = if Mix.env != :test do
      [
        worker(SlackBot.SlackRtm, [Application.get_env(:slack, :api_token)])
      ]
    else
      []
    end

    opts = [strategy: :one_for_one, name: SlackBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
