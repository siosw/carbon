defmodule Carbon.PastTest do
  use ExUnit.Case, async: true
  use Carbon.RepoCase
  use Mimic

  alias Carbon.{Past, Intensity}

  @example_intensity %Intensity{
    actual: 135,
    forecast: 132,
    from: ~U[2020-02-02 23:00:00Z],
    index: "low",
    to: ~U[2020-02-02 23:30:00Z]
  }

  test "days_to_date_list/1 returns expected list" do
    {:ok, _} = @example_intensity
    |> Carbon.Intensity.changeset(%{})
    |> Carbon.Repo.insert()

    assert Past.days_to_date_list(0) == ["2020-02-02"]
    assert Past.days_to_date_list(1) == ["2020-02-02", "2020-02-01"]
    assert Past.days_to_date_list(3) == ["2020-02-02", "2020-02-01", "2020-01-31", "2020-01-30"]
  end

  test "days_to_date_list/1 handles negative input" do
    assert Past.days_to_date_list(-2) == []
  end
end
