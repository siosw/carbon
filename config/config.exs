import Config

config :carbon, Carbon.Repo,
  database: "carbon_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  log: false # false to disable, :info to show

config :carbon, ecto_repos: [Carbon.Repo]

import_config "#{Mix.env()}.exs"
