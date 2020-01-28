defmodule Rabbit.HelloAcceptor do
  require Logger

  alias Rabbit.Utils

  def accept(socket) do
    Logger.info("Starting HelloAcceptor#accept")
    handle_command(socket)
  end

  defp handle_command(client_socket) do
    command =
      Utils.read_line(client_socket)
      |> Utils.parse_command()

    exec_command(client_socket, command)
  end

  defp exec_command(client_socket, ["hello", "producer"]) do
    Logger.info("Producer registered")
    Utils.write_line(client_socket, "Producer registered")
    Task.async(fn -> Rabbit.Producer.handle_command(client_socket) end)
  end

  defp exec_command(client_socket, ["hello", "consumer"]) do
    Logger.info("Consumer registered")
    Utils.write_line(client_socket, "Consumer registered")
    {:ok, _pid} = GenServer.start_link(Rabbit.Consumer, client_socket)
  end

  defp exec_command(client_socket, _) do
    Logger.info("HelloAcceptor received an unexpected command")
    Utils.write_line(client_socket, "Unexpected command")
    handle_command(client_socket)
  end
end
