import Config

config :carbon, Carbon.Repo,
  database: "carbon_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  log: false

config :carbon, ecto_repos: [Carbon.Repo]
