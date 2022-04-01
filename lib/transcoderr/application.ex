defmodule Transcoderr.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Transcoderr.Repo,
      # Start the Telemetry supervisor
      TranscoderrWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Transcoderr.PubSub},
      # Start the Endpoint (http/https)
      TranscoderrWeb.Endpoint,
      # Start a worker by calling: Transcoderr.Worker.start_link(arg)
      # {Transcoderr.Worker, arg},
      {DynamicSupervisor, name: Transcoderr.FilesystemSupervisor, strategy: :one_for_one}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Transcoderr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TranscoderrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
