defmodule SupercolliderCubes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SupercolliderCubesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SupercolliderCubes.PubSub},
      # Start the Endpoint (http/https)
      SupercolliderCubesWeb.Endpoint,
      # scsynth external OS process
      SupercolliderCubes.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SupercolliderCubes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SupercolliderCubesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
