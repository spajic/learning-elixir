defmodule DetectGithubUserProgrammingLanguages.CLI do
  @moduledoc """
  Работа с командной строкой
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` может быть -h или --help, тогда возвращаем :help

  Иначе `argv` это github username, возвращаем его
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
      # |> elem(1)
      |> args_to_internal_representation()
  end

  def args_to_internal_representation({ [ help: true ], _, _ }), do: :help

  def args_to_internal_representation({ _, [ user ], _ }), do: user

  # unexpected argument case
  def args_to_internal_representation(_), do: :help
end
