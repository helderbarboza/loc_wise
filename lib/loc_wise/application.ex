defmodule LocWise.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LocWiseWeb.Telemetry,
      # Start the Ecto repository
      LocWise.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LocWise.PubSub},
      # Start Finch
      {Finch, name: LocWise.Finch},
      # Start the Endpoint (http/https)
      LocWiseWeb.Endpoint,
      # Start the cache supervisor
      {LocWise.LocalCache, []}
      # Start a worker by calling: LocWise.Worker.start_link(arg)
      # {LocWise.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LocWise.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LocWiseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
