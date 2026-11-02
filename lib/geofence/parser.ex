defmodule Spot.Geofence.Parser do
  @moduledoc "Parses GeoFenceEditorDb rows into geofence maps."

  def parse_line(line) do
    with [id, name | _] <- String.split(line, ";"),
         {id, ""} <- id |> String.trim() |> Integer.parse(),
         [_, coords] <- Regex.run(~r/POLYGON\(\((.+)\)\)/, line) do
      {:ok, %{id: id, name: blank_to_nil(name), polygon: parse_coords(coords)}}
    else
      _ -> {:error, :invalid_row}
    end
  end

  def parse(body) do
    body
    |> String.split("\n", trim: true)
    |> Enum.flat_map(fn line ->
      case parse_line(line) do
        {:ok, fence} -> [fence]
        _ -> []
      end
    end)
  end

  defp blank_to_nil(s), do: if(String.trim(s) == "", do: nil, else: String.trim(s))

  defp parse_coords(coords) do
    coords
    |> String.split(",", trim: true)
    |> Enum.map(fn pair ->
      [lon, lat] = pair |> String.split() |> Enum.map(&String.to_float/1)
      {lat, lon}
    end)
  end
end
