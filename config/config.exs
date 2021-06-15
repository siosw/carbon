import Config

config :carbon, Carbon.Repo,
  database: "carbon_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  log: false # false to disable, :info to show

config :carbon,
  ecto_repos: [Carbon.Repo],
  gap_interval: 24 * 60 * 60 * 1000,
  today_interval: 12 * 60 * 60 * 1000,
  past_interval: 60 * 60 * 1000

import_config "#{Mix.env()}.exs"
