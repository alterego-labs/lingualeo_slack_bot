defmodule Storage.DB.Repo.Migrations.AddWordsTable do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :external_id, :string, size: 128
      add :value, :string, size: 256
      add :translation, :string, size: 256
      add :transcription, :string, size: 256
      add :sound_url, :string, size: 256
      add :pic_url, :string, size: 256
      add :user_id, :integer

      timestamps
    end
  end
end
