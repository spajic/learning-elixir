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
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      { [ help: true ], _, _ }
        -> :help

      { _, [ user ], _ }
        -> user

      _ -> :help
    end
  end
end
