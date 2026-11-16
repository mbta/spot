defmodule Spot.Geofences do
  @moduledoc "In-memory geofences from `subway_inputs`, loaded once at startup into `:persistent_term`."

  alias SubwayInputs.Geofence
  alias SubwayInputs.Geofence.Storage

  @key {__MODULE__, :geofences}

  @spec load!(Path.t()) :: :ok
  def load!(path \\ Storage.default_path()) do
    case Storage.read(path) do
      {:ok, fences} ->
        :persistent_term.put(@key, Map.new(fences, &{&1.id, &1}))

      {:error, reason} ->
        raise "could not load geofences from #{path}: #{inspect(reason)}"
    end
  end

  @spec all() :: [Geofence.t()]
  def all, do: @key |> :persistent_term.get() |> Map.values() |> Enum.sort_by(& &1.id)

  @spec get(integer()) :: Geofence.t() | nil
  def get(id), do: @key |> :persistent_term.get() |> Map.get(id)
end
