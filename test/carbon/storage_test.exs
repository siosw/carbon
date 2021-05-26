defmodule Carbon.StorageTest do
  use Carbon.RepoCase

  alias Carbon.{Intensity, Storage}

  @example_intensity %Intensity{
    actual: 135,
    forecast: 132,
    from: ~U[2021-05-24 23:00:00Z],
    index: "low",
    to: ~U[2021-05-24 23:30:00Z]
  }

  @example_intensity_with_id %Intensity{
    actual: 135,
    forecast: 132,
    from: ~U[2021-05-24 23:00:00Z],
    id: 1,
    index: "low",
    to: ~U[2021-05-24 23:30:00Z]
  }

  test "insert_and_count/1 inserts intensity and returns count" do
    assert Storage.insert_and_count(@example_intensity) == 1
    assert Storage.insert_and_count(@example_intensity) == 0
  end

  test "insert_and_count/1 rejects intensity with id" do
    assert_raise ArgumentError, fn ->
      Storage.insert_and_count(%Intensity{@example_intensity | id: 999})
    end
  end

end
