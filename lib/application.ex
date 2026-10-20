defmodule Spot.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, Application.fetch_env!(:spot, DNSCluster)}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Spot.Supervisor)
  end
end
