# Buisness-logic implementation
defmodule MyRedis.Logic do
  def set(key, value, state) do
    state_with_new_key = Map.put_new(state, key, value)
    new_state = %{state_with_new_key | key => value}
    { value, new_state }
  end

  def get(key, state) do
    { state[key], state }
  end

  def del(key, state) do
    { state[key], Map.delete(state, key) }
  end

  def flushdb() do
    { nil, %{} }
  end
end
