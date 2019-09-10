import Config

config :ptr, PtrWeb.Endpoint, secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :ptr, Ptr.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: 15

config :ptr, Ptr.Notifications.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.fetch_env!("SENDGRID_API_KEY")
