# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :transcoderr,
  ecto_repos: [Transcoderr.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :transcoderr, TranscoderrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fkjAjZeatiwV7NlpuTTSiRVyc/J+Fw5AlJFe6M7503KeliJG5X50n5pUTTqFgKdo",
  render_errors: [view: TranscoderrWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Transcoderr.PubSub,
  live_view: [signing_salt: "ssQMNVDv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
