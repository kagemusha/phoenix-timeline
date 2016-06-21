use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_timeline, PhoenixTimeline.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_timeline, PhoenixTimeline.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phoenix_timeline_test",
  hostname: "localhost",
  #ownership_timeout: 300_000, #useful when PRYing
  pool: Ecto.Adapters.SQL.Sandbox
