defmodule Carbon.Previous do
  import Ecto.Query, only: [from: 2]

  alias Carbon.Storage

  def get(days) do
    days
    |> days_to_date_list()
    |> download_dates()
  end

  def days_to_date_list(days) do
    0..-days
    |> Enum.map(&Date.add(last_known_date(), &1))
    |> Enum.map(&Date.to_string/1)
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

  def download_dates(dates) do
    dates
    |> Task.async_stream(Storage, :store_date, [], max_concurrency: System.schedulers_online() * 2)
    |> Enum.to_list()
    |> Keyword.get_values(:ok)
    |> Enum.sum()
  end
end
