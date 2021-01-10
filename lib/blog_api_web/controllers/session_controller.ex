defmodule BlogApiWeb.SessionController do
  use BlogApiWeb, :controller

  action_fallback BlogApiWeb.FallbackController

  def create(conn, %{"email" => email, "password": password}) do

  end
end
