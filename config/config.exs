# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ptr,
  ecto_repos: [Ptr.Repo]

# Configures the endpoint
config :ptr, PtrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+5uJsn8iBpaUpQeRSLPjD7Yfie6r6A9bijONBcFXxh9P7M26BNEQp/EIiKD+D/jW",
  render_errors: [view: PtrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ptr.PubSub, adapter: Phoenix.PubSub.PG2]

# Gettext config
config :ptr, PtrWeb.Gettext, default_locale: "es_AR"

# Ecto timestamps
config :ptr, Ptr.Repo, migration_timestamps: [type: :utc_datetime]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason

# PaperTrail config
config :paper_trail, repo: Ptr.Repo

# Scrivener HTML config
config :scrivener_html,
  routes_helper: PtrWeb.Router.Helpers,
  view_style: :bulma

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
