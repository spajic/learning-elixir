defmodule MyRedis.TcpServer do
  require Logger

  def main(argv) do
    { port, _ } = Integer.parse(List.first(argv))
    accept(port)
  end

  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    MyRedis.start_link
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> parse_command()
    |> exec_command()
    |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp parse_command(str) do
    String.split(str)
  end

  defp exec_command(["SET", key, value]), do: MyRedis.set(key, value)

  defp exec_command(["GET", key]), do: MyRedis.get(key)

  defp exec_command(["DEL", key]), do: MyRedis.del(key)

  defp exec_command(["FLUSHDB"]), do: MyRedis.flushdb()

  defp exec_command(["INSPECT"]), do: MyRedis.inspect()

  defp exec_command(_) do
    "Unexpected command!"
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line <> "\n")
  end
end
