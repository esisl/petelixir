defmodule Petelixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PetelixirWeb.Telemetry,
      Petelixir.Repo,
      {DNSCluster, query: Application.get_env(:petelixir, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Petelixir.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Petelixir.Finch},
      # Start a worker by calling: Petelixir.Worker.start_link(arg)
      # {Petelixir.Worker, arg},
      # Start to serve requests, typically the last entry
      PetelixirWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Petelixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PetelixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
