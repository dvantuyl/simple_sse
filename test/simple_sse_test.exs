defmodule SimpleSseTest do
  use ExUnit.Case
  doctest SimpleSse

  test "greets the world" do
    assert SimpleSse.hello() == :world
  end
end
