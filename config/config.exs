# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ptr,
  ecto_repos: [Ptr.Repo]

# Configures the endpoint
config :ptr, PtrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+5uJsn8iBpaUpQeRSLPjD7Yfie6r6A9bijONBcFXxh9P7M26BNEQp/EIiKD+D/jW",
  render_errors: [view: PtrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ptr.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Gettext config
config :ptr, PtrWeb.Gettext, default_locale: "es_AR"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
