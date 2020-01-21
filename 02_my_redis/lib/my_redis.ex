# API of MyRedis
defmodule MyRedis do
  @server MyRedis.Server

  def start_link() do
    GenServer.start_link(@server, %{}, name: @server)
  end

  def set(key, value) do
    GenServer.call(@server, {:set, key, value})
  end

  def get(key) do
    GenServer.call(@server, {:get, key})
  end

  def del(key) do
    GenServer.call(@server, {:del, key})
  end

  def flushdb() do
    GenServer.call(@server, :flushdb)
  end
end
