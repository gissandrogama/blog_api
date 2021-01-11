defmodule BlogApiWeb.SessionController do
  use BlogApiWeb, :controller
  alias BlogApiWeb.Auth.Guardian

  action_fallback BlogApiWeb.FallbackController

  def create(conn, params) do
    with {:ok, _user, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> token)
      |> render("show.json", %{token: token})
    end
  end
end
