# API of MyRedis
defmodule MyRedis do
  @server MyRedis.Server

  def start_link(), do: GenServer.start_link(@server, %{}, name: @server)

  def set(key, value), do: GenServer.call(@server, {:set, key, value})

  def get(key), do: GenServer.call(@server, {:get, key})

  def del(key), do: GenServer.call(@server, {:del, key})

  def flushdb(), do: GenServer.call(@server, :flushdb)

  def inspect(), do: GenServer.call(@server, :inspect)
end
