defmodule Spot.CertTest do
  require Logger

  use GenServer

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_opts) do
    test()

    {:ok, nil}
  end

  # Request that chains to compromised cert: emSign Root TLS CA - G3
  defp test_host, do: "ov-g3b-emudhra.we-have-a-problem.com"
  defp test_path, do: "/?t=1792621266006"
  defp test_url, do: "https://#{test_host()}#{test_path()}"

  defp test do
    case Req.get(test_url()) do
      {:ok, response} -> Logger.info("cert_test req ok response=#{inspect(response)}")
      {:error, exception} -> Logger.error("cert_test req error response=#{inspect(exception)}")
    end
  end
end
