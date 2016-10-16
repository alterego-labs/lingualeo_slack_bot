defmodule LingualeoGateway do
  @moduledoc """
  Application's main module.

  Is represented as top level supervisor.
  """

  use Application

  @doc """
  Starts application.
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(LingualeoGateway.ApiPoint, []),
    ]

    opts = [strategy: :one_for_one, name: LingualeoGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
