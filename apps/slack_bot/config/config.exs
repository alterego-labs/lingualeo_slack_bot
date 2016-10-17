use Mix.Config

config :slack, api_token: System.get_env("SLACK_BOT_TOKEN")
