defmodule BlogApiWeb.SearchController do
  use BlogApiWeb, :controller

  alias BlogApi.Posts

  action_fallback BlogApiWeb.FallbackController

  def show(conn, params) do
    posts = Posts.list_search(params) |> BlogApi.Repo.preload(:user)
    render(conn, "show.json", posts: posts)
  end

end
