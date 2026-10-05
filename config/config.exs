import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase
config :ex_aws, http_client: ExAws.Request.Req

import_config "#{config_env()}.exs"
