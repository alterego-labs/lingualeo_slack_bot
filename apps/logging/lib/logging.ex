defmodule Logging do
  @moduledoc """
  Logging application's main module.

  Is represented as top level supervisor.
  """

  use Application

  @doc """
  Starts an application
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
    ]

    opts = [strategy: :one_for_one, name: Logging.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
