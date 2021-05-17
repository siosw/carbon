defmodule Carbon.Intensity do
  use Ecto.Schema

  schema "intensities" do
    field :from, :utc_datetime
    field :to, :utc_datetime
    field :actual, :integer
    field :forecast, :integer
    field :index, :string
  end

  def changeset(intensity, params \\ %{}) do
    intensity
    |> Ecto.Changeset.cast(params, [:from, :to, :actual, :forecast, :index])
    |> Ecto.Changeset.validate_required([:from, :to, :actual])
  end

end
