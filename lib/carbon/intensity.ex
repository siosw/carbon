defmodule Carbon.Intensity do
  use Ecto.Schema

  schema "intensities" do
    field :from, :utc_datetime, null: false
    field :to, :utc_datetime, null: false
    field :actual, :integer, null: false
    field :forecast, :integer
    field :index, :string
  end

  def changeset(intensity, params \\ %{}) do
    intensity
    |> Ecto.Changeset.cast(params, [:from, :to, :actual, :forecast, :index])
    |> Ecto.Changeset.validate_required([:from, :to, :actual])
    |> Ecto.Changeset.unique_constraint(:from, name: :intensities_from_to_index)
  end

end
