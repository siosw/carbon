defmodule Carbon.PastTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Carbon.{Storage, Past}

  test "days_to_date_list/1 returns expected list" do
    {:ok, date} = Date.from_iso8601("2020-02-02")

    Storage
    |> stub(:get_last_known_date, fn -> date end)

    assert Past.days_to_date_list(0) == ["2020-02-02"]
    assert Past.days_to_date_list(1) == ["2020-02-02", "2020-02-01"]
    assert Past.days_to_date_list(3) == ["2020-02-02", "2020-02-01", "2020-01-31", "2020-01-30"]
  end

  test "days_to_date_list/1 handles negative input" do
    assert Past.days_to_date_list(-2) == []
  end


end
