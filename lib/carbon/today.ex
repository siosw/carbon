defmodule Carbon.Today do

  def get() do
    date = Date.utc_today()
    |> Date.to_string()

    Carbon.Storage.fetch_and_store_dates([date])
  end
end
