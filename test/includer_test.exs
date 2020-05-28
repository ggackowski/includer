defmodule IncluderTest do
  use ExUnit.Case
  doctest Includer

  test "greets the world" do
    assert Includer.hello() == :world
  end
end
