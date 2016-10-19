use Mix.Config

config :storage, ecto_repos: Storage.DB.Repo

import_config "#{Mix.env}.exs"
