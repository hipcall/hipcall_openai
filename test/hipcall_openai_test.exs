defmodule HipcallOpenaiTest do
  use ExUnit.Case
  doctest HipcallOpenai

  @tag :skip
  test "greets the world" do
    assert HipcallOpenai.hello() == :world
  end
end
