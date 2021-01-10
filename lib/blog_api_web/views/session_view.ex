defmodule BlogApiWeb.SessionView do
  use BlogApiWeb, :view

  alias BlogApiWeb.UserView

  def render("show.json", %{user: user, token: token}) do
    %{
      user: UserView.render("show.json", user: user),
      token: token
    }
  end
end
