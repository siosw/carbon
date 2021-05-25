defmodule Carbon.Past do
  import Ecto.Query, only: [from: 2]

  alias Carbon.Storage

  def get(days) do
    days
    |> days_to_date_list()
    |> Storage.download_dates()
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
end
