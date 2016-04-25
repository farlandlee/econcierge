use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :grid, Grid.Endpoint,
  http: [port: 4001],
  server: false,
  send_external_emails: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :grid, Grid.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "grid_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
