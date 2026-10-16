import Config

if config_env() != :test do
  # Distributed Elixir
  config :spot, DNSCluster, query: System.get_env("DNS_CLUSTER_QUERY") || :ignore
end
