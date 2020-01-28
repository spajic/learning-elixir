defmodule Rabbit.Utils do
  def read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  def write_line(socket, line) do
    :gen_tcp.send(socket, line <> "\n")
  end

  def parse_command(command_string) do
    # TODO: downcase
    String.split(command_string)
  end
end
