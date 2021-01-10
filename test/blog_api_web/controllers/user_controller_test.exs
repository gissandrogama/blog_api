defmodule BlogApiWeb.UserControllerTest do
  use BlogApiWeb.ConnCase

  alias BlogApi.Users
  alias BlogApi.Users.User
  alias BlogApi.UserFixture

  def fixture(:user) do
    {:ok, user} = Users.create_user(UserFixture.valid_user())
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: UserFixture.valid_user())
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "displayName" => "some displayName",
               "email" => "some@email.com",
               "image" => "some image"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: UserFixture.invalid_user())
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: UserFixture.update_user())
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "displayName" => "some updated display_name",
               "email" => "some_updated@email.com",
               "image" => "some updated image"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: UserFixture.invalid_user())
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  describe "renders errors when displayName is invalid" do
    test "when displayName is less than 8 characters", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{
        display_name: "some",
        email: "some@email.com",
        image: "some image",
        password: "some password_hash"
      })
      assert json_response(conn, 400) == %{"message" => "\"displayName\" length must be at least 8 characters long"}
    end
  end

  describe "renders errors when password is invalid" do
    test "when password is less than 6 characters", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{
        display_name: "some displayName",
        email: "some@email.com",
        image: "some image",
        password: "12345"
      })
      assert json_response(conn, 400) == %{"message" => "\"password\" length must be 6 characters long"}
    end

    test "when password not passed", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{
        display_name: "some displayName",
        email: "some@email.com",
        image: "some image"
      })
      assert json_response(conn, 400) == %{"message" => "\"password\" is required"}
    end
  end

  describe "renders errors when email is invalid" do
    test "when email is spent without the domain", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{
        display_name: "some displayName",
        email: "some@",
        image: "some image",
        password: "some password_hash"
      })
      assert json_response(conn, 400) == %{"message" => "\"email\" must be a valid email"}
    end

    test "when email is passed only with the domain", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{
        display_name: "some displayName",
        email: "@email.com",
        image: "some image",
        password: "some password_hash"
      })
      assert json_response(conn, 400) == %{"message" => "\"email\" must be a valid email"}
    end

    test "when email is passed without the '@'", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{
        display_name: "some displayName",
        email: "somedisplayName",
        image: "some image",
        password: "some password_hash"
      })
      assert json_response(conn, 400) == %{"message" => "\"email\" must be a valid email"}
    end

    test "when email not passed", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{
        display_name: "some displayName",
        image: "some image",
        password: "some password_hash"
      })
      assert json_response(conn, 400) == %{"message" => "\"email\" is required"}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
