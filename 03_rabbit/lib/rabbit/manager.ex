defmodule Rabbit.Manager do
  use GenServer
  require Logger

  @server Rabbit.Manager

  def start_link(port) do
    GenServer.start_link(@server, port, name: @server)
  end

  @impl true
  def init(port) do
    Logger.info("Manager #{inspect(self())} started")
    Task.async(fn -> @server.listen_socket(port) end)
    {:ok, nil}
  end

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
