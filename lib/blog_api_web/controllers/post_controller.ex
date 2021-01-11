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
        |> put_resp_header("location", Routes.post_path(conn, :show, post))
        |> render("show.json", post: post)

      {status, message} ->
        conn
        |> put_status(status)
        |> json(message)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
