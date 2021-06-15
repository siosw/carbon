defmodule Carbon.Past do

  alias Carbon.Storage

  def get(days) do
    days
    |> days_to_date_list()
    |> Storage.fetch_and_store_dates()
  end

  def days_to_date_list(days) when days >= 0 do
    0..-days
    |> Enum.map(&Date.add(Storage.get_last_known_date(), &1))
    |> Enum.map(&Date.to_string/1)
  end

  def days_to_date_list(_days), do: []
end
