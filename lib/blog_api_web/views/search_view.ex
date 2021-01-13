defmodule BlogApiWeb.SearchView do
  use BlogApiWeb, :view
  alias BlogApiWeb.SearchView

  def render("show.json", %{searchs: searchs}) do
    render_many(searchs, SearchView, "search.json")
  end

  def render("search.json", %{search: search}) do
    %{
      id: search.id,
      title: search.title,
      content: search.content,
      user: %{
        id: search.user.id,
        displayName: search.user.display_name,
        email: search.user.email,
        image: search.user.image
      }
    }
  end
end
