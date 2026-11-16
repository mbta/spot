defmodule Spot.GeofencesTest do
  # load!/1 replaces global :persistent_term state
  use ExUnit.Case, async: false

  alias SubwayInputs.Geofence
  alias SubwayInputs.Geofence.Storage

  @moduletag :tmp_dir

  @fences [
    %Geofence{
      id: 9_000_100,
      name: "Test Station",
      polygon: [{42.0, -71.0}, {42.0, -71.001}, {42.001, -71.001}, {42.0, -71.0}]
    },
    %Geofence{
      id: 9_000_200,
      name: nil,
      polygon: [{42.1, -71.1}, {42.1, -71.101}, {42.101, -71.101}, {42.1, -71.1}]
    }
  ]

  setup %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "geofences.json")
    Storage.write!(path, @fences)

    on_exit(fn -> Spot.Geofences.load!() end)

    %{path: path}
  end

  describe "load!/1" do
    test "loads geofences from the file into memory", %{path: path} do
      assert :ok = Spot.Geofences.load!(path)
      assert Spot.Geofences.all() == @fences
    end

    test "raises when the file is missing", %{tmp_dir: tmp_dir} do
      assert_raise RuntimeError, ~r/enoent/, fn ->
        Spot.Geofences.load!(Path.join(tmp_dir, "missing.json"))
      end
    end

    test "raises when the file is not valid geofence JSON", %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "bad.json")
      File.write!(path, "not json")

      assert_raise RuntimeError, ~r/invalid_json/, fn -> Spot.Geofences.load!(path) end
    end

    test "replaces previously loaded geofences", %{path: path} do
      Spot.Geofences.load!(path)
      Storage.write!(path, [hd(@fences)])
      Spot.Geofences.load!(path)

      assert Spot.Geofences.all() == [hd(@fences)]
    end
  end

  describe "get/1" do
    setup %{path: path} do
      Spot.Geofences.load!(path)
    end

    test "returns the geofence with the given id" do
      assert Spot.Geofences.get(9_000_200) == List.last(@fences)
    end

    test "returns nil for an unknown id" do
      assert Spot.Geofences.get(1) == nil
    end
  end

  test "geofences are loaded when the application starts" do
    assert Spot.Geofences.all() != []
  end
end
