defmodule Carbon.Util do
  def map_to_intensity(m) do
    int = Map.get(m, "intensity")

    %Carbon.Intensity{
      from: to_timestamp(Map.get(m, "from")),
      to: to_timestamp(Map.get(m, "to")),
      actual: Map.get(int, "actual"),
      forecast: Map.get(int, "forecast"),
      index: Map.get(int, "index")
    }
  end

  def to_timestamp(time_string) do
    conversion =
      time_string
      |> String.replace("Z", ":00Z")
      |> DateTime.from_iso8601()

    case conversion do
      {:ok, timestamp, _} -> timestamp
      {:error, _} -> raise ArgumentError
    end
  end
end
