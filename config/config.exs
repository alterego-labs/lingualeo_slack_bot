use Mix.Config

config :storage, ecto_repos: [Storage.DB.Repo]

config :slack, api_token: System.get_env("SLACK_BOT_TOKEN")

import_config "#{Mix.env}.exs"

