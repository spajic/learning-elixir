defmodule Rabbit.Consumer do
  use GenServer
  require Logger
  alias Rabbit.Utils

  @impl true
  def init(client_socket) do
    Logger.info("Consumer #{inspect(self())} started")
    {:ok, client_socket}
  end

  @impl true
  def handle_call({:new_message, new_message}, _from, client_socket) do
    Logger.info("Consumer received new message: #{new_message}")
    Utils.write_line(client_socket, new_message)

    {:reply, :message_received, client_socket}
  end
end
