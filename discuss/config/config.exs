# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, DiscussWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "d2ENH6mGz00StAkcu02CiHbGvBCn+wAskQxeQgHV6WWB23kEfJq/nACkXLgFInRQ",
  render_errors: [view: DiscussWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Discuss.PubSub,
  live_view: [signing_salt: "yNnuQFtO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []},
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "fdc659c91bd24a29f0ba",
  client_secret: "28d05a46f1fc9170ef752059f44bf6af76a17091"
#  client_secret: System.get_env("ELIXIR_STUDY_GIT_SECRET")


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
