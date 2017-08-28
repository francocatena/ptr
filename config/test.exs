use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ptr, PtrWeb.Endpoint,
  http: [port: 4001],
  server: false

# Gettext config
config :ptr, PtrWeb.Gettext, default_locale: "en"

# Bamboo test adapter
config :ptr, Ptr.Notifications.Mailer,
  adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ptr, Ptr.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ptr_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, log_rounds: 4
