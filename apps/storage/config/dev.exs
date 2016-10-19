use Mix.Config

config :storage, Storage.DB.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "lingualeo_slack_bot_storage_dev",
  username: "root",
  password: "",
  hostname: "localhost",
  port: 3306
