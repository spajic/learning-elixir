defmodule Rabbit.Consumer do
  use GenServer
  require Logger
  alias Rabbit.Utils

  @impl true
  def init({client_socket, q_name}) do
    Logger.info("Starting consumer for q #{q_name}")

    # TODO: подписываться на несколько очередей
    Rabbit.QManager.add_consumer_to_q(q_name, self())
    Logger.info("Starting tcp handler for consumer in separate task")
    Task.async(fn -> handle_command(client_socket) end)

    Logger.info("Consumer #{inspect(self())} started")
    {:ok, client_socket}
  end

  @impl true
  def handle_call({:new_message, new_message}, _from, client_socket) do
    Logger.info("Consumer received new message: #{new_message}")
    Utils.write_line(client_socket, new_message)

    {:reply, :message_received, client_socket}
  end

  defp handle_command(client_socket) do
    Logger.info("Handle command in producer (only exit, nothing yet)")

    command_string = Utils.read_line(client_socket)
    Utils.write_line(client_socket, command_string)

    handle_command(client_socket)
  end
end
