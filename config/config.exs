# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :grid,
  env: Mix.env,
  # Secrets, tokens, all the good stuff
  postmark_server_token: {:system, "POSTMARK_API_TOKEN"},
  tripadvisor_api_key: "disabled",
  google_client_secret: {:system, "GOOGLE_CLIENT_SECRET"},
  google_client_id: {:system, "GOOGLE_CLIENT_ID"},
  notify_vendors: false

# Configures the endpoint
config :grid, Grid.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "RPL0bZbv1bcYJBeyW7+5P+owCy+Hq/W4uNlfyMY9btmOBEX7ECbcR/8a4LaHvFDB",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Grid.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_KEY"}, :instance_role]

config :rollbax,
  access_token: System.get_env("ROLLBAR_TOKEN"),
  environment: Mix.env

config :stripity_stripe,
  secret_key: System.get_env("STRIPE_SECRET_TOKEN")

config :logger, Rollbax.Notifier,
  level: :error

config :arc, bucket: "dev-outpost-grid"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
