defmodule BlogApiWeb.SearchController do
  use BlogApiWeb, :controller

  alias BlogApi.Posts

  action_fallback BlogApiWeb.FallbackController

  def show(conn, %{"serach" => params}) do
    searchs = Posts.list_search(params) |> BlogApi.Repo.preload(:user)
    render(conn, "show.json", searchs: searchs)
  end
end
