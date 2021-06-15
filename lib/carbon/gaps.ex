defmodule Carbon.Gaps do
  import Ecto.Query, only: [from: 2]
  require Logger

  alias Carbon.Storage

  def get() do
    timestamps = get_missing_timestamps()
    Logger.info "number of gaps found: #{length(timestamps)}"

    timestamps
    |> Enum.map(&DateTime.to_date/1)
    |> Enum.map(&Date.to_string/1)
    |> Storage.fetch_and_store_dates()
  end

  def get_missing_timestamps() do
    query =
      from i_o in Carbon.Intensity,
      as: :intensity,
      where: not exists(
        from i_i in Carbon.Intensity,
        where: i_i.from == datetime_add(parent_as(:intensity).from, 30, "minute"),
        select: nil
      ),
      select: i_o.from

    Carbon.Repo.all(query)
  end
end
