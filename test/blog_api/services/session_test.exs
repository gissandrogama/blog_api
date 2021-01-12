defmodule BlogApi.Users.Services.SessionTest do
  use BlogApi.DataCase

  alias BlogApi.{Services.Session, UserFixture, Users}

  test "authenticate/2 should return user" do
    user = UserFixture.user_fixture(%{email: "teste@email.com", password: "123123"})
    {:ok, user_authenticate} = Session.authenticate("teste@email.com", "123123")
    assert "teste@email.com" == user_authenticate.email
  end

  test "authenticate/2 should return not_found" do
    result = Session.authenticate("some123@email.com", "some password_hash")
    assert {:error, :not_found} == result
  end

  test "authenticate/2 unauthorized password invalid" do
    user_fixture()
    assert {:error, :unauthorized} == Session.authenticate("some@email.com", "123456")
  end
end
