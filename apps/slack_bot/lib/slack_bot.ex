defmodule SlackBot do
  @moduledoc """
  SlackBot application's main module.

  Is represented as top level supervisor.
  """

  use Application

  @doc """
  Starts application.
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(SlackBot.SlackRtm, [Application.get_env(:slack, :api_token)])
    ]

    opts = [strategy: :one_for_one, name: SlackBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
