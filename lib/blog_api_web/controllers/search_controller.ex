defmodule BlogApiWeb.SearchController do
  use BlogApiWeb, :controller

  alias BlogApi.Services.Search

  action_fallback BlogApiWeb.FallbackController

  def show(conn, params) do
    searchs = Search.list_search(params)
    render(conn, "show.json", searchs: searchs)
  end
end
