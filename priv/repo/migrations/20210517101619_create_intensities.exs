defmodule Carbon.Repo.Migrations.CreateIntensities do
  use Ecto.Migration

  def change do
    create table(:intensities) do
      add :from, :utc_datetime
      add :to, :utc_datetime
      add :actual, :integer
      add :forecast, :integer
      add :index, :string
    end

    create unique_index(:intensities, [:from, :to], name: :intensities_from_to_index)
  end
end

# sample query

# import Ecto.Query, only: [from: 2]
# {:ok, ts, _} = DateTime.from_iso8601 "2020-08-08T12:00:00Z"
# q = from i in Carbon.Intensity, where: i.from == ^ts
# Carbon.Repo.all q
