# Server
defmodule MyRedis.Server do
  use GenServer
  alias MyRedis.Logic

  def init(_) do
    { :ok, %{} }
  end

  def handle_call({:set, key, value}, _from, state) do
    { reply_value, new_state } = Logic.set(key, value, state)
    { :reply, reply_value, new_state }
  end

  def handle_call({:get, key}, _from, state) do
    { reply_value, new_state } = Logic.get(key, state)
    { :reply, reply_value, new_state }
  end

  def handle_call({:del, key}, _from, state) do
    { reply_value, new_state } = Logic.del(key, state)
    { :reply, reply_value, new_state }
  end

  def handle_call(:flushdb, _from, _state) do
    { reply_value, new_state } = Logic.flushdb()
    { :reply, reply_value, new_state }
  end

  def handle_call(:inspect, _from, state) do
    { reply_value, new_state } = Logic.inspect(state)
    { :reply, reply_value, new_state }
  end
end
