defmodule Rabbit.QManager do
  use GenServer
  require Logger

  @server Rabbit.QManager

  # Interface
  def start_link(_) do
    GenServer.start_link(@server, nil, name: @server)
  end

  def push_msg_to_q(q_name, msg) do
    GenServer.call(@server, {:push_msg_to_q, q_name, msg})
  end

  def add_consumer_to_q(q_name, from_consumer) do
    GenServer.call(@server, {:add_consumer_to_q, q_name, from_consumer})
  end

  def log_state() do
    GenServer.call(@server, :log_state)
  end

  def log_all_qs() do
    GenServer.call(@server, :log_all_qs)
  end

  # Implementation
  @impl true
  def init(_) do
    Logger.info("QManager #{inspect(self())} started")
    {:ok, Map.new()}
  end

  @impl true
  def handle_call({:push_msg_to_q, q_name, msg}, _from, state) do
    Logger.info("QManager received message for q '#{q_name}': '#{msg}'")

    new_state = create_q_if_not_exists(q_name, state)
    q_pid = new_state[q_name]
    Logger.info("Gonna send msg to Q #{inspect(q_pid)}")
    Rabbit.Q.push_msg(q_pid, msg)

    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:add_consumer_to_q, q_name, from_consumer}, _from, state) do
    Logger.info("QManager adding consumer #{inspect(from_consumer)} to #{q_name}")

    q_pid = state[q_name]
    Logger.info("Gonna add consumer to q #{q_name} with pid #{inspect(q_pid)}")
    Rabbit.Q.add_consumer(q_pid, from_consumer)

    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:log_state, _from, state) do
    Logger.info("QManager state: #{inspect(state)}")

    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:log_all_qs, _from, state) do
    Logger.info("Log all qs")
    Map.values(state)
      |> Enum.each(fn (pid) -> Rabbit.Q.log_state(pid) end)

    {:reply, :ok, state}
  end

  defp create_q_if_not_exists(q_name, state) do
    if state[q_name] do
      state
    else
      Map.put(state, q_name, create_q(q_name))
    end
  end

  defp create_q(q_name) do
    {:ok, pid} = Rabbit.Q.start(q_name)
    pid
  end
end
