defmodule Carbon.Storage do
  import Ecto.Query, only: [from: 2]

  alias Carbon.HttpRequest
  alias Carbon.Storage

  def download_dates(dates) do
    dates
    |> Task.async_stream(Storage, :store_date, [], max_concurrency: System.schedulers_online() * 2)
    |> Enum.to_list()
    |> Keyword.get_values(:ok)
    |> Enum.sum()
  end

  def last_known_date() do
    sq = from s_d in Carbon.Intensity, select: min(s_d.to)
    from(t in Carbon.Intensity, where: t.to in subquery(sq), select: t.to)
    |> Carbon.Repo.one!()
    |> case do
      nil -> Date.utc_today()
      timestamp -> DateTime.to_date(timestamp)
    end
  end

  def store_date(date) do
    {:ok, resp} = HttpRequest.intensity(date)
    save(resp)
  end

  def save(%{status: 200} = resp) do
    resp.body
    |> Map.get("data")
    |> Enum.map(&map_to_intensity/1)
    |> Enum.map(&insert_and_count/1)
    |> Enum.sum()
  end

  def save(resp) do
    raise RuntimeError, "#{resp.status} response from API"
  end

  def insert_and_count(intensity) do
    intensity
    |> Carbon.Intensity.changeset(%{})
    |> Carbon.Repo.insert()
    |> case do
      {:ok, _} -> 1
      {:error, _} -> 0
    end
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
