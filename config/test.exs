use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ptr, PtrWeb.Endpoint,
  http: [port: 4001],
  server: false

# Gettext config
config :ptr, PtrWeb.Gettext, default_locale: "en"

# Bamboo test adapter
config :ptr, Ptr.Notifications.Mailer, adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ptr, Ptr.Repo,
  username: if(System.get_env("TRAVIS"), do: "postgres", else: "ptr"),
  password: if(System.get_env("TRAVIS"), do: "postgres", else: "ptr"),
  database: "ptr_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir,
  t_cost: 1,
  m_cost: 5
