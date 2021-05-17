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
  end
end
