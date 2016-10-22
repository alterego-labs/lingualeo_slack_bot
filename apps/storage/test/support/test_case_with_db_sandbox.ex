defmodule TestCaseWithDbSandbox do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Storage.Factory
      alias Storage.DB.Repo
    end
  end


  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Storage.DB.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Storage.DB.Repo, {:shared, self()})
    :ok
  end
end
