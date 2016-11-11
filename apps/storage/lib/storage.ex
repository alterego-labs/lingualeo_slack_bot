defmodule Storage do
  @moduledoc """
  Storage application's main module.

  Storage application provides an API to be able to work with the database. Only this application
  has an access to the DB.
  
  For more details what available API methods are see `Storage.API` module.
  """

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
