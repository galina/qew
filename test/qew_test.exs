defmodule QewTest do
  use ExUnit.Case
  doctest Qew

  test "greets the world" do
    assert Qew.hello() == :world
  end
end
