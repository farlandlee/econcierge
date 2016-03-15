use Mix.Config

# Copy from production with some updates for staging.
config :grid, Grid.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "outpost-grid-staging.herokuapp.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :grid,
  tripadvisor_api_key: {:system, "TRIPADVISOR_API_KEY"},
  booking_emails_bcc: "dev@outpostjh.com",
  notify_vendors: false

# Do not print debug messages in production
config :logger,
  level: :info,
  handle_otp_reports: true,
  handle_sasl_reports: true

config :logger,
  backends: [:console, Rollbax.Notifier]

config :arc, bucket: "outpost-grid-staging"

config :grid, Grid.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20
