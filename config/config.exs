# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :phoenix_timeline, PhoenixTimeline.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "DdINGXkkYMMJ8PUjDBYm8hncKHgrKVBH+24m0X6GHRPdhyq5MQM+7RzMEfNB5Hfd",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: PhoenixTimeline.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configure ecto repos
config :phoenix_timeline, ecto_repos: [PhoenixTimeline.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

