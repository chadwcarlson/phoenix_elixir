# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_elixir,
  ecto_repos: [PhoenixElixir.Repo]

# Configures the endpoint
config :phoenix_elixir, PhoenixElixir.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZflceawcJX377AEthJJJb32zmgA/5LYJlDoq5PVxXaZmf3kzbNOZhO/AcDU7uWQ0",
  render_errors: [view: PhoenixElixir.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixElixir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

# Login auth.
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT, # optional
  issuer: "PhoenixElixir",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "XvB1szxDOlM5vKK9Te+PmRSF1hbhx8qLawz/YOIfYibHg+m4PBRKJ17bHsms9Xv2", # don't deploy
  serializers: PhoenixElixir.GuardianSerializer


import_config "#{Mix.env}.exs"
