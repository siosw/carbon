defmodule Carbon.Storage do
  import Ecto.Query, only: [from: 2]

  alias Carbon.{HttpRequest, Storage, Util}

  def download_dates(dates) do
    dates
    |> Task.async_stream(Storage, :store_date, [], max_concurrency: System.schedulers_online() * 2)
    |> Enum.to_list()
    |> Keyword.get_values(:ok)
    |> Enum.sum()
  end

  def get_last_known_date() do
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
    |> Enum.map(&Util.map_to_intensity/1)
    |> Enum.map(&insert_and_count/1)
    |> Enum.sum()
  end

  def save(resp) do
    raise RuntimeError, "#{resp.status} response from API"
  end

  def insert_and_count(%Carbon.Intensity{id: nil} = intensity) do
    intensity
    |> Carbon.Intensity.changeset(%{})
    |> Carbon.Repo.insert()
    |> case do
      {:ok, _} -> 1
      {:error, _} -> 0
    end
  end

  def insert_and_count(%Carbon.Intensity{id: _some} = _intensity), do: raise ArgumentError
end
