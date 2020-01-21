# Implementation
defmodule MyRedis.Server do
  use GenServer

  def init(_) do
    { :ok, %{} }
  end

  def handle_call({:set, key, value}, _from, state) do
    state_with_new_key = Map.put_new(state, key, value)
    state_with_updated_key = %{state_with_new_key | key => value}
    { :reply, state_with_updated_key, state_with_updated_key }
  end

  def handle_call({:get, key}, _from, state) do
    { :reply, state[key], state }
  end

  def handle_call({:del, key}, _from, state) do
    new_state = Map.delete(state, key)
    { :reply, new_state, new_state }
  end

  def handle_call(:flushdb, _from, _state) do
    new_state = %{}
    { :reply, new_state, new_state }
  end
end
