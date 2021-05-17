defmodule Carbon.Storage do
  alias Carbon.HttpRequest

  def store_date(date) do
    {:ok, resp} = HttpRequest.intensity(date)
    resp |> save
  end

  def save(%{status: 200} = resp) do
    resp.body
    |> Map.get("data")
    |> Enum.map(&map_to_intensity/1)
    |> Enum.each(&Carbon.Repo.insert!/1)
  end

  def save(resp) do
    throw "API returned #{resp.status}"
  end

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
    {:ok, timestamp, _} =
      time_string
      |> String.replace("Z", ":00Z")
      |> DateTime.from_iso8601()

    timestamp
  end
end
