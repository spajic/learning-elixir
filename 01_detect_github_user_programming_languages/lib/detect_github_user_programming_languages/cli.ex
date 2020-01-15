defmodule DetectGithubUserProgrammingLanguages.CLI do
  @moduledoc """
  Работа с командной строкой
  """

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  def process(:help) do
    IO.puts """
    usage: detect_github_user_programming_languages spajic
    """
    System.halt(0)
  end

  def process(username) do
    DetectGithubUserProgrammingLanguages.Github.fetch(username)
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

  def args_to_internal_representation({ _, [ username ], _ }), do: username

  # unexpected argument case
  def args_to_internal_representation(_), do: :help
end
