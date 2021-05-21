defmodule Carbon.Previous do
  import Ecto.Query, only: [from: 2]

  alias Carbon.Storage

  # bench: 27.441625s for 100 days
  def get_sync(days) do
    0..-days
    |> Enum.map(&Date.add(last_known_date(), &1))
    |> Enum.map(&Date.to_string/1)
    |> Enum.map(&Storage.store_date/1)
    |> Enum.sum()
  end

  # bench: 2.894843s for 100 days
  def get_async(days) do
    0..-days
    |> Enum.map(&Date.add(last_known_date(), &1))
    |> Enum.map(&Date.to_string/1)
    |> Enum.map(&spawn_store_date/1)
    |> Enum.map(&receive_result/1)
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

  defp receive_result(_pid) do
    receive do
      {:result, count} -> count
    end
  end

  defp spawn_store_date(date) do
    parent = self()
    spawn(fn -> send(parent, {:result, wrap_store(date)}) end)
  end

  defp wrap_store(date) do
    try do
      Storage.store_date(date)
    rescue
      _ -> 0
    end
  end
end
