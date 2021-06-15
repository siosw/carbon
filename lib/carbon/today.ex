defmodule Carbon.Today do

  @moduledoc """
  This module provides a get/0 function to fetch the current Date and save it in the DB.
  """

  def get() do
    date = Date.utc_today()
    |> Date.to_string()

    Carbon.Storage.fetch_and_store_dates([date])
  end
end
