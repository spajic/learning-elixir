defmodule Rabbit.Q do
  use GenServer
  require Logger

  # Interface
  def start(name) do
    Logger.info("Starting Q '#{name}' #{inspect(self())}")
    GenServer.start(Rabbit.Q, name)
  end

  def push_msg(pid, msg) do
    GenServer.call(pid, {:push_msg, msg})
  end

  # Implementation
  @impl true
  def init(name) do
    Logger.info("Q '#{name}' #{inspect(self())} started")

    {:ok, %{name: name, msgs: [], consumers: []}}
  end

  @impl true
  def handle_call({:push_msg, msg}, _from, state) do
    Logger.info("Pushing msg #{msg} to q #{state[:name]}")

    Map.put(state, :msgs, [state[:msgs] | msg])

    # TODO: вынести в callback
    # state = deliver_msgs(state)

    {:reply, :ok, state}
  end

  defp deliver_msgs(state) do
    Logger.info("Delivering msgs from q #{state[:name]}")

    send_msg_to_all_consumers = fn(msg) ->
      Enum.each(
        state[:consumers],
        fn (consumer) -> GenServer.call(consumer, {:new_message, msg}) end
      )
    end

    Enum.each(state[:msgs], send_msg_to_all_consumers)

    Map.put(state, :msgs, [])
  end
end
