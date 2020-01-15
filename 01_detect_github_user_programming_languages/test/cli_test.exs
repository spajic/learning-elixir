defmodule CliTest do
  use ExUnit.Case
  doctest DetectGithubUserProgrammingLanguages

  import DetectGithubUserProgrammingLanguages.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "pumpum"]) == :help
    assert parse_args(["--help", "pumpum"]) == :help
  end

  test "username returned if one argument passed" do
    assert parse_args(["spajic"]) == "spajic"
  end

  test ":help returned in case of unexpected params" do
    assert parse_args(["spajic", "pumpum"]) == :help
  end
end
