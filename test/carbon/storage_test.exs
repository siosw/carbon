defmodule Carbon.StorageTest do
  use Carbon.RepoCase
  use Mimic

  alias Carbon.{Intensity, Storage, HttpRequest}

  @example_intensity %Intensity{
    actual: 135,
    forecast: 132,
    from: ~U[2021-05-24 23:00:00Z],
    index: "low",
    to: ~U[2021-05-24 23:30:00Z]
  }

  @example_response %Tesla.Env{
    body: %{
      "data" => [
        %{
          "from" => "2020-02-02T00:00Z",
          "intensity" => %{
            "actual" => 181,
            "forecast" => 180,
            "index" => "moderate"
          },
          "to" => "2020-02-02T00:30Z"
        },
        %{
          "from" => "2020-02-02T00:30Z",
          "intensity" => %{
            "actual" => 180,
            "forecast" => 178,
            "index" => "moderate"
          },
          "to" => "2020-02-02T01:00Z"
        },
      ]
    },
    method: :get,
    status: 200,
  }

  test "store_intensity/1 inserts correctly" do
    {status, inserted} = Storage.store_intensity(@example_intensity)
    assert status == :ok
    assert inserted.id != nil
  end

  test "response_to_intensities/1 returns expected Intensities" do
    [first, second] = Storage.response_to_intensities(@example_response)
    assert first.actual == 181
    assert second.actual == 180
  end

  test "response_to_intensities/1 raises on non 200 response code" do
    assert_raise RuntimeError, fn ->
      Storage.response_to_intensities(%Tesla.Env{status: 404})
    end
  end

  test "last_known_date/1 returns expected date" do
    {:ok, date} = Date.from_iso8601("2021-05-24")

    {:ok, _} = @example_intensity
    |> Carbon.Intensity.changeset(%{})
    |> Carbon.Repo.insert()

    assert Storage.get_last_known_date() == date
  end
end
