defmodule Rabbit.Producer do
  require Logger

  alias Rabbit.Utils

  def handle_command(client_socket) do
    Logger.info("Handle command in producer")

    response =
      Utils.read_line(client_socket)
      |> Utils.parse_command()
      |> exec_command

    Utils.write_line(client_socket, response)

    handle_command(client_socket)
  end

  defp exec_command(["push", q_name, message]) do
    "push to #{q_name}: '#{message}'"
    Rabbit.QManager.push_msg_to_q(q_name, message)
    "Message published"
  end

  defp exec_command(_) do
    "You're producer! You expected only to push to queues"
  end
end
