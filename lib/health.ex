defmodule Spot.Health do
  require Logger

  @spec healthy?() :: :ok
  def healthy? do
    Logger.info("healthy")
    :ok
  end
end
