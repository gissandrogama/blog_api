defmodule BlogApiWeb.SessionController do
  use BlogApiWeb, :controller
  alias BlogApiWeb.Auth.Guardian

  action_fallback BlogApiWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, _user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:ok)
      |> render("show.json", %{token: token})
    end
  end
end
