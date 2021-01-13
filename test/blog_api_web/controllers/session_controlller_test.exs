defmodule BlogApiWeb.SessionControllerTest do
  use BlogApiWeb.ConnCase

  import BlogApiWeb.Auth.Guardian

  alias BlogApi.UserFixture

  setup %{conn: conn} do
    user = UserFixture.user_fixture(%{email: "certo@email.com"})
    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: conn}
  end

  describe "session tests" do
    test "should authenticate with valid user", %{conn: conn} do
      conn =
        conn
        |> post(Routes.session_path(conn, :create), %{
          email: "certo@email.com",
          password: "123456"
        })

      assert %{"token" => _} = json_response(conn, 200)
    end

    test "should not authenticate with invalid user", %{conn: conn} do
      conn =
        conn
        |> post(Routes.session_path(conn, :create), %{
          email: "some@email.com",
          password: "123456"
        })

      assert json_response(conn, 400) == %{"message" => "Campos inválidos"}
    end
  end
end
