defmodule Carbon.StorageTest do
  use ExUnit.Case, async: true

  alias Carbon.Storage

  test "save/1 throws on non 200 response codes" do
    assert_raise RuntimeError, fn -> Storage.save(%Tesla.Env{status: 500}) end
  end

  test "to_timestamp/1 truncated iso 8601 gets converted correctly" do
    assert ~U[2018-01-20 12:00:00Z] == Storage.to_timestamp("2018-01-20T12:00Z")
    assert ~U[2018-12-20 23:30:00Z] == Storage.to_timestamp("2018-12-20T23:30Z")
  end

  test "to_timestamp/1 raises on invalid argument" do
    assert_raise ArgumentError, fn -> Storage.to_timestamp("invalid") end
    assert_raise ArgumentError, fn -> Storage.to_timestamp("2018-12-20T23:30:00Z") end
  end

  test "map_to_intensity/1 correctly converts map to struct" do
    map = %{
      "from" => "2020-08-08T16:00Z",
      "intensity" => %{
        "actual" => 185,
        "forecast" => 178,
        "index" => "moderate"
      },
      "to" => "2020-08-08T16:30Z"
    }

    expected = %Carbon.Intensity{
      actual: 185,
      forecast: 178,
      from: ~U[2020-08-08 16:00:00Z],
      id: nil,
      index: "moderate",
      to: ~U[2020-08-08 16:30:00Z]
    }

    assert expected == Storage.map_to_intensity(map)
  end

  test "map_to_intensity/1 raises on invalid argument" do
    assert_raise BadMapError, fn -> Storage.map_to_intensity({}) end
  end
end
