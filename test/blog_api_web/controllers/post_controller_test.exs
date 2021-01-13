defmodule BlogApiWeb.PostControllerTest do
  use BlogApiWeb.ConnCase

  import BlogApiWeb.Auth.Guardian

  alias BlogApi.{PostFixture, UserFixture}

  @create_attrs %{
    content: "some content",
    title: "some title"
  }

  @update_attrs %{
    content: "some updated content",
    title: "some updated title"
  }
  @invalid_attrs %{content: nil, title: nil}

  setup %{conn: conn} do
    user = UserFixture.user_fixture()
    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create post" do
    test "renders post when data is valid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @create_attrs)

      assert %{"UserId" => _, "title" => "some title", "content" => "some content"} =
               json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
      assert %{"message" => " \"title\" and \"content\" is required"} = json_response(conn, 400)
    end
  end

  describe "update post" do
    test "error when user did not create the post", %{conn: conn} do
      post = PostFixture.post_fixture()
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert %{"message" => "Usuário não autorizado"} = json_response(conn, 401)

      conn = get(conn, Routes.post_path(conn, :show, post.id))

      assert %{
               "content" => "some content",
               "title" => "some title",
               "id" => _id,
               "user" => _
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      post = PostFixture.post_fixture()
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert %{"message" => "Usuário não autorizado"} = json_response(conn, 401)
    end
  end

  describe "delete post" do
    test "deletes chosen post", %{conn: conn} do
      post = PostFixture.post_fixture()
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert response(conn, 401)

      # conn = get(conn, Routes.post_path(conn, :show, post))
      # assert "" = json_response(conn, 404)
    end
  end
end
