defmodule Carbon.Storage do
  import Ecto.Query, only: [from: 2]

  alias Carbon.{HttpRequest, Storage, Util}

  def fetch_and_store_dates(dates) when is_list(dates) do
    dates
    |> Task.async_stream(Storage, :fetch_date, [])
    |> Stream.map(&Kernel.elem(&1, 1))
    |> Stream.flat_map(&response_to_intensities/1)
    |> Stream.map(&store_intensity/1)
    |> Enum.to_list()
    |> Keyword.get_values(:ok)
    |> length
  end

  def fetch_date(date) do
    {:ok, resp} =  HttpRequest.intensity(date)
    resp
  end

  def response_to_intensities(%{status: 200} = resp) do
    resp.body
    |> Map.get("data")
    |> Enum.map(&Util.map_to_intensity/1)
  end

  def response_to_intensities(resp) do
    IO.inspect(resp)
    raise RuntimeError, "#{resp.status} response from API"
  end

  def store_intensity(intensity) do
    intensity
    |> Carbon.Intensity.changeset(%{})
    |> Carbon.Repo.insert()
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
end
