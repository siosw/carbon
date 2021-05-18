defmodule Carbon.Previous do
  alias Carbon.Storage

  # bench: 27.441625s for 100 days
  def get_sync(days) do
    0..-days
    |> Enum.map(&Date.add(Date.utc_today(), &1))
    |> Enum.map(&Date.to_string/1)
    |> Enum.map(&Storage.store_date/1)
    |> Enum.sum()
  end

  # bench: 2.894843s for 100 days
  def get_async(days) do
    0..-days
    |> Enum.map(&Date.add(Date.utc_today(), &1))
    |> Enum.map(&Date.to_string/1)
    |> Enum.map(&spawn_store_date/1)
    |> Enum.map(&receive_result/1)
    |> Enum.sum()
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
