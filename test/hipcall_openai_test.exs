defmodule HipcallOpenaiTest do
  use ExUnit.Case
  doctest HipcallOpenai

  test "greets the world" do
    assert HipcallOpenai.hello() == :world
  end
end
