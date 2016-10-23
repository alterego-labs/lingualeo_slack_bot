use Mix.Config

config :storage, ecto_repos: [Storage.DB.Repo]

config :slack, api_token: System.get_env("SLACK_BOT_TOKEN")

config :logger,
  backends: [:console],
  utc_log: true,
  level: :debug

config :logger, :console,
  level: :debug,
  format: "\n$time $metadata[$level] $levelpad$message\n",
  metadata: [:app]


import_config "#{Mix.env}.exs"

