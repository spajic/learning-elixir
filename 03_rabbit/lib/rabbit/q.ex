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

  def add_consumer(pid, consumer_pid) do
    GenServer.call(pid, {:add_consumer, consumer_pid})
  end

  def log_state(pid) do
    GenServer.call(pid, :log_state)
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

    state_with_new_msg = Map.put(state, :msgs, state[:msgs] ++ [msg])

    # TODO: вынести в callback
    new_state = deliver_msgs(state_with_new_msg, state[:consumers])

    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:add_consumer, consumer_pid}, _from, state) do
    Logger.info("Adding consumer #{inspect(consumer_pid)} to q #{state[:name]}")

    new_state = Map.put(state, :consumers, state[:consumers] ++ [consumer_pid])

    # TODO: рассылать сообщения и после добавления consumer

    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call(:log_state, _from, state) do
    Logger.info("Logging state of Q #{state[:name]}")
    Logger.info("msgs: #{inspect(state[:msgs])}")
    Logger.info("consumers: #{inspect(state[:consumers])}")

    {:reply, :ok, state}
  end

  defp deliver_msgs(state, []) do
    Logger.info("No consumers yet, do nothing")

    state
  end

  defp deliver_msgs(state, consumers) do
    Logger.info("Delivering msgs from q '#{state[:name]}'")
    Logger.info("msgs: #{inspect(state[:msgs])}")

    send_msg_to_all_consumers = fn msg ->
      Enum.each(
        consumers,
        fn consumer -> Rabbit.Consumer.receive_msg(consumer, msg) end
      )
    end

    Enum.each(state[:msgs], send_msg_to_all_consumers)

    Map.put(state, :msgs, [])
  end
end
