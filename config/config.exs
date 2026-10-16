import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase
config :ex_aws, http_client: ExAws.Request.Req

# Distributed Elixir; overridden with a real query in runtime.exs outside of
# tests.
config :spot, DNSCluster, query: :ignore, log: :info

import_config "#{config_env()}.exs"
