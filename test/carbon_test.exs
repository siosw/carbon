defmodule CarbonTest do
  use ExUnit.Case
  doctest Carbon

  test "greets the world" do
    assert Carbon.hello() == :world
  end
end
