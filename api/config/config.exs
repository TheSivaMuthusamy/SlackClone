# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :slack_clone,
  ecto_repos: [SlackClone.Repo]

# Configures the endpoint
config :slack_clone, SlackClone.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DA/c/99KqVbVfLl2BqwcEL9WqInsYUq0R9gXmm4GV6Vq8wjZLRjKj7xZ595s9+eh",
  render_errors: [view: SlackClone.ErrorView, accepts: ~w(json)],
  pubsub: [name: SlackClone.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
config :guardian, Guardian,
  issuer: "SlackClone",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: SlackClone.GuardianSerializer

import_config "#{Mix.env}.exs"


