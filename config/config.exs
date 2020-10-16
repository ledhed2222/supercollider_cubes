# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :supercollider_cubes, SupercolliderCubesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JeG00LcO8l1B0QO9DKpcpZ/Sydt35HENG70Jf3ot11oFakbIkY+GvwwOVlMHqOwg",
  render_errors: [view: SupercolliderCubesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SupercolliderCubes.PubSub,
  live_view: [signing_salt: "+EXbYBMn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :membrane_core, Membrane.Logger,
  loggers: [
    %{
      module: Membrane.Loggers.Console,
      id: :console,
      level: :warn,
      options: [],
      tags: [:all]
    }
  ],
  level: :warn

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
