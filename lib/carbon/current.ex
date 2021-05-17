defmodule Carbon.Current do

  # get latest timestamp
  #   if nil get today
  #   else get from now back to latest timestamp
  # run store date for each date
  def get() do
    case last_timestamp() do
      nil ->
        {:ok, timestamp} = DateTime.now("Etc/UTC")
        timestamp
        |> DateTime.truncate(:second)
      timestamp ->
        timestamp
    end
  end

  defp last_timestamp() do
    try do
      Carbon.Intensity
      |> Ecto.Query.first(asc: :from)
      |> Carbon.Repo.one()
      |> Map.get(:from)
    rescue
      BadMapError -> nil
    end
  end

end
