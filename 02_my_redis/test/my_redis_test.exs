defmodule MyRedisTest do
  use ExUnit.Case
  doctest MyRedis

  test "greets the world" do
    assert MyRedis.hello() == :world
  end
end
