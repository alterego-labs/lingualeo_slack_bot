defmodule Storage.DB.Repo.Migrations.AddWordTrainingsTable do
  use Ecto.Migration

  def change do
    create table(:word_trainings) do
      add :user_id, :integer
      add :word_id, :integer
      add :status, :string, size: 128
      add :attempts_to_success, :integer, default: 0

      timestamps
    end

    create index(:word_trainings, [:user_id])
    create index(:word_trainings, [:word_id])
  end
end
