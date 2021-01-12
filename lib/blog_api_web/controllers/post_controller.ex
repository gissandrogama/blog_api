defmodule BlogApiWeb.PostController do
  use BlogApiWeb, :controller

  alias BlogApi.Posts
  alias BlogApi.Posts.Post

  action_fallback BlogApiWeb.FallbackController

  def index(conn, _params) do
    posts = Posts.list_posts() |> BlogApi.Repo.preload(:user)
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    user = Guardian.Plug.current_resource(conn)

    post_params =
      post_params
      |> Map.put("user_id", user.id)

    case Posts.create_post(post_params) do
      {:ok, %Post{} = post} ->
        conn
        |> put_status(:created)
        |> render("create_show.json", post: post)

      {status, message} ->
        conn
        |> put_status(status)
        |> json(message)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id) |> BlogApi.Repo.preload(:user)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    user = Guardian.Plug.current_resource(conn)
    post = Posts.get_post!(id)

    if user.id == post.user_id do
      with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
        cond do
          Map.fetch(post_params, "title") == :error ->
            conn
            |> put_status(:bad_request)
            |> json(%{message: "\"title\" is required"})

          Map.fetch(post_params, "content") == :error ->
            conn
            |> put_status(:bad_request)
            |> json(%{message: "\"content\" is required"})

          true ->
            render(conn, "create_show.json", post: post)
        end
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{message: "Usuário não uatorizado"})
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
