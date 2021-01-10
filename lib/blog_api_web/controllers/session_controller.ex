defmodule BlogApiWeb.SessionController do
  use BlogApiWeb, :controller

  action_fallback BlogApiWeb.FallbackController

  @user %BlogApi.Users.User{
    display_name: "fulano amaral",
    email: "fulano45@gmail.com",
    id: "66068608-cc37-4888-9d57-c138a2874d40",
    image: "string",
    inserted_at: ~N[2021-01-09 22:08:06],
    password: nil,
    password_hash:
      "$argon2id$v=19$m=131072,t=8,p=4$69VCWh8A/mvawnET4+42JA$LA4NMPsSkAaHkYhWSgUPFtdmck4fzi7kpwcrNx5h9tk",
    updated_at: ~N[2021-01-09 22:08:06]
  }

  def create(conn, %{"email" => email, "password" => password}) do
    conn
    |> put_status(:created)
    |> render("show.json", %{user: @user, token: "token"})
  end
end
