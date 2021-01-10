defmodule BlogApiWeb.SessionView do
  use BlogApiWeb, :view

  def render("show.json", %{token: token}) do
    %{
      token: token
    }
  end
end
