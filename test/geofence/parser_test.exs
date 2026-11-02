defmodule Spot.Geofence.ParserTest do
  use ExUnit.Case, async: true

  alias Spot.Geofence.Parser

  @polygon1 "9000100; Test Station; 1; 0; 0; 0; 0; 0; 0; 1; ; 0; 0; 0; 0; 0; 1; 225; 10; 25; 0; 1,2,3; ; ; 1; 2; 4; 100; 42.0005; -71.0005; POLYGON((-71.0010 42.0000,-71.0010 42.0010,-71.0000 42.0010,-71.0000 42.0000,-71.0010 42.0000))"

  @polygon2 "9000200; ; 0; 0; 0; 0; 0; 0; 0; 1; ; 0; 0; 0; 0; 0; 1; 225; 10; 25; 0; 1,2,3; ; ; 1; 2; 4; 100; 42.0005; -71.0015; POLYGON((-71.0020 42.0000,-71.0020 42.0010,-71.0010 42.0010,-71.0010 42.0000,-71.0020 42.0000))"

  describe "parse_line/1" do
    test "parses id, name, and polygon (as {lat, lon} tuples)" do
      assert {:ok, fence} = Parser.parse_line(@polygon1)
      assert fence.id == 9_000_100
      assert fence.name == "Test Station"

      assert fence.polygon == [
               {42.0, -71.001},
               {42.001, -71.001},
               {42.001, -71.0},
               {42.0, -71.0},
               {42.0, -71.001}
             ]
    end

    test "blank name becomes nil" do
      {:ok, fence} = Parser.parse_line(@polygon2)
      assert fence.name == nil
    end
  end

  describe "parse/1" do
    test "returns fences, skipping non-row lines like `Array`" do
      body = Enum.join(["Array", @polygon1, "Array", @polygon2], "\n")
      assert [%{id: 9_000_100}, %{id: 9_000_200}] = Parser.parse(body)
    end
  end
end
