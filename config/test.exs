use Mix.Config

config :storage, Storage.DB.Repo,
  adapter: Ecto.Adapters.MySQL,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "lingualeo_slack_bot_storage_test",
  username: "root",
  password: "",
  hostname: "localhost",
  port: 3306
