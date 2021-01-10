defmodule BlogApiWeb.UserView do
  use BlogApiWeb, :view
  alias BlogApiWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      displayName: user.display_name,
      email: user.email,
      image: user.image
    }
  end
end
