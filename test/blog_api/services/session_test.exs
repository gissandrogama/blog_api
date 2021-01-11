defmodule BlogApi.Users.Services.SessionTest do
  use BlogApi.DataCase

  alias BlogApi.Users
  alias BlogApi.UserFixture
  alias BlogApi.Services.Session

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(UserFixture.valid_user())
      |> Users.create_user()

    user
  end

  test "authenticate/2 should return user" do
    user_fixture()
    {:ok, user_authenticate} = Session.authenticate("some@email.com", "some password_hash")
    assert "some@email.com" == user_authenticate.email
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
