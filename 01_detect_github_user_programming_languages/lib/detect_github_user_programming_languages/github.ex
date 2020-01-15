defmodule DetectGithubUserProgrammingLanguages.Github do
  @user_agent [ {"User-agent", "Elixir"} ]

  def fetch(username) do
    repos_url(username)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def repos_url(username) do
    "https://api.github.com/users/#{username}/repos"
  end

  def handle_response({ :ok, %{status_code: 200, body: body}}) do
    { :ok, body }
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    { :error, body }
  end
end
