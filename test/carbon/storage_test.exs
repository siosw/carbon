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

  test "insert_and_count/1 inserts intensity and returns count" do
    assert Storage.insert_and_count(@example_intensity) == 1
    assert Storage.insert_and_count(@example_intensity) == 0
  end

  test "insert_and_count/1 rejects intensity with id" do
    assert_raise ArgumentError, fn ->
      Storage.insert_and_count(%Intensity{@example_intensity | id: 999})
    end
  end

  test "store_date/1 stores Intensities for a date" do
    HttpRequest
    |> stub(:intensity, fn _date -> {:ok, @example_response} end)

    Storage.store_date("2020-02-02")

    assert Carbon.Repo.get_by(Intensity, forecast: 180, actual: 181) != nil
    assert Carbon.Repo.get_by(Intensity, forecast: 178, actual: 180) != nil
  end

  test "store_date/1 raises on non 200 response code" do
    HttpRequest
    |> stub(:intensity, fn _date -> {:ok, %Tesla.Env{status: 400}} end)

    assert_raise RuntimeError, fn ->
      Storage.store_date("2020-02-02")
    end
  end

  test "store_date/1 raises on unsuccessful http request" do
    HttpRequest
    |> stub(:intensity, fn _date -> {:error, RuntimeError} end)

    assert_raise RuntimeError, fn ->
      Storage.store_date("2020-02-02")
    end
  end
end
