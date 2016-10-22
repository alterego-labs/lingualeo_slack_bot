defmodule Storage do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Storage.DB.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Storage.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
