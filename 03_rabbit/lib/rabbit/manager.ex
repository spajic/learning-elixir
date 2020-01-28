defmodule Rabbit.Manager do
  require Logger

  def listen_socket(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("listening socket on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client_socket} = :gen_tcp.accept(socket)
    Task.async(fn -> Rabbit.HelloAcceptor.accept(client_socket) end)

    loop_acceptor(socket)
  end
end
