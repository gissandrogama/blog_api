defmodule BlogApiWeb.UserController do
  use BlogApiWeb, :controller

  alias BlogApi.Users
  alias BlogApi.Users.User

  action_fallback BlogApiWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)

      {status, message} ->
        conn
        |> put_status(status)
        |> json(message)
    end
  end

  def show(conn, %{"id" => id}) do
    Users.get_user!(id)
    |> case do
      %User{} = user ->
        render(conn, "show.json", user: user)

      {status, message} ->
        conn
        |> put_status(status)
        |> json(%{message: message})
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, %User{} = user} ->
        render(conn, "show.json", user: user)

      {status, message} ->
        conn
        |> put_status(status)
        |> json(message)
    end
  end

  def delete(conn, _params) do
    id = Guardian.Plug.current_resource(conn).id
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
