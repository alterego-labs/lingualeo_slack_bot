defmodule Storage.DB.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string, size: 128
      add :cookies, :text
      add :response_hash, :text

      timestamps
    end
  end
end
