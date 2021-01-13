defmodule BlogApi.Services.Search do
  @moduledoc """
  module has function to search posts
  """

  import Ecto.Query, warn: false
  alias BlogApi.Repo

  alias BlogApi.Posts.Post

  @doc """
  Returns the list of posts, according to the parameter passed.

  ## Examples

      iex> list_search(%{"q" => ""})
      [%Post{}, ...]

  """
  def list_search(params) do
    search_term = get_in(params, ["q"])

    Post
    |> Post.search(search_term)
    |> Repo.all()
    |> BlogApi.Repo.preload(:user)
  end
end
