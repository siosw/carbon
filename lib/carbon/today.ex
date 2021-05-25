defmodule Carbon.Today do

  def get() do
    Date.utc_today()
    |> Date.to_string()
    |> Carbon.Storage.store_date()
  end
end
