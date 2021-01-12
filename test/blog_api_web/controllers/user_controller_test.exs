defmodule BlogApiWeb.UserControllerTest do
  use BlogApiWeb.ConnCase, async: true

  import BlogApiWeb.Auth.Guardian
  import BlogApi.UserFixture

  @valid_user %{
    display_name: "some displayName",
    email: "some@email.com",
    image: "some image",
    password: "123456"
  }

  @update_user %{
    display_name: "some updated display_name",
    email: "some_updated@email.com",
    image: "some updated image",
    password: "123456"
  }

  @invalid_user %{
    display_name: nil,
    email: nil,
    image: nil,
    password: nil
  }

  setup %{conn: conn} do
   user = user_fixture(%{email: "fulanosilva@email.com"})
    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      user_fixture()

      conn =
        conn
        |> get(Routes.user_path(conn, :index))

      assert json_response(conn, 200) |> Enum.count() == 2
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @valid_user)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => _,
               "displayName" => "some displayName",
               "email" => "some@email.com",
               "image" => "some image"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_user)
      assert %{"message" => " \"email\" and \"password\" is required"} = json_response(conn, 400)
    end
  end

  describe "update user" do
    test "renders user when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_user)

      assert %{
               "id" => _,
               "displayName" => "some updated display_name",
               "email" => "some_updated@email.com",
               "image" => "some updated image"
             } = json_response(conn, 200)

      conn = get(conn, Routes.user_path(conn, :show, user.id))

      assert %{
               "id" => _,
               "displayName" => "some updated display_name",
               "email" => "some_updated@email.com",
               "image" => "some updated image"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture(%{email: "henry@email.com"})
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_user)

      assert %{"message" => " \"email\" and \"password\" is required"} = json_response(conn, 400)
    end
  end

  describe "delete user" do
    test "deletes chosen user", %{conn: conn} do
      conn = delete(conn, Routes.user_path(conn, :delete))
      assert response(conn, 204)
    end
  end

  describe "show user" do
    test "render error when id was passed and does not exist", %{conn: conn} do
      user_id = "e7cc5d37-4b42-43ba-92ee-0da884f2d475"
      conn = get(conn, Routes.user_path(conn, :show, user_id))
      assert %{"message" => "Usuário não existe"} = json_response(conn, 404)
    end
  end

  describe "renders errors when displayName is invalid" do
    test "when displayName is less than 8 characters", %{conn: conn} do
      conn =
        post(conn, Routes.user_path(conn, :create),
          user: %{
            display_name: "some",
            email: "some@email.com",
            image: "some image",
            password: "some password_hash"
          }
        )

      assert json_response(conn, 400) == %{
               "message" => "\"displayName\" length must be at least 8 characters long"
             }
    end
  end

  describe "renders errors when password is invalid" do
    test "when password is less than 6 characters", %{conn: conn} do
      conn =
        post(conn, Routes.user_path(conn, :create),
          user: %{
            display_name: "some displayName",
            email: "some@email.com",
            image: "some image",
            password: "12345"
          }
        )

      assert json_response(conn, 400) == %{
               "message" => "\"password\" length must be 6 characters long"
             }
    end

    test "when password not passed", %{conn: conn} do
      conn =
        post(conn, Routes.user_path(conn, :create),
          user: %{
            display_name: "some displayName",
            email: "some@email.com",
            image: "some image"
          }
        )

      assert json_response(conn, 400) == %{"message" => "\"password\" is required"}
    end
  end

  describe "renders errors when email is invalid" do
    test "when email is spent without the domain", %{conn: conn} do
      conn =
        post(conn, Routes.user_path(conn, :create),
          user: %{
            display_name: "some displayName",
            email: "some@",
            image: "some image",
            password: "some password_hash"
          }
        )

      assert json_response(conn, 400) == %{"message" => "\"email\" must be a valid email"}
    end

    test "when email is passed only with the domain", %{conn: conn} do
      conn =
        post(conn, Routes.user_path(conn, :create),
          user: %{
            display_name: "some displayName",
            email: "@email.com",
            image: "some image",
            password: "some password_hash"
          }
        )

      assert json_response(conn, 400) == %{"message" => "\"email\" must be a valid email"}
    end

    test "when email is passed without the '@'", %{conn: conn} do
      conn =
        post(conn, Routes.user_path(conn, :create),
          user: %{
            display_name: "some displayName",
            email: "somedisplayName",
            image: "some image",
            password: "some password_hash"
          }
        )

      assert json_response(conn, 400) == %{"message" => "\"email\" must be a valid email"}
    end

    test "when email not passed", %{conn: conn} do
      conn =
        post(conn, Routes.user_path(conn, :create),
          user: %{
            display_name: "some displayName",
            image: "some image",
            password: "some password_hash"
          }
        )

      assert json_response(conn, 400) == %{"message" => "\"email\" is required"}
    end
  end
end
