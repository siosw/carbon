use Mix.Config

config :carbon, Carbon.Repo,
  database: "carbon_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
