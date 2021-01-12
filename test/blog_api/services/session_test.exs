defmodule BlogApi.Users.Services.SessionTest do
  use BlogApi.DataCase

  alias BlogApi.{Services.Session, UserFixture}

  describe "authenticate/1" do
    test "should return user" do
      UserFixture.user_fixture(%{email: "teste@email.com", password: "123123"})

      {:ok, user_authenticate} =
        Session.authenticate(%{"email" => "teste@email.com", "password" => "123123"})

      assert "teste@email.com" == user_authenticate.email
    end

    test "return error when email does not exist" do
      UserFixture.user_fixture(%{email: "teste@email.com", password: "123123"})
      result = Session.authenticate(%{"email" => "teste1231@email.com", "password" => "123123"})
      assert {:error, "Campos inválidos"} == result
    end

    test "return error password invalid" do
      UserFixture.user_fixture(%{email: "teste@email.com", password: "123123"})
      result = Session.authenticate(%{"email" => "teste@email.com", "password" => "123456"})
      assert {:error, "password inválido"} == result
    end

    test "return password error when only email is passed" do
      UserFixture.user_fixture(%{email: "teste@email.com", password: "123123"})
      result = Session.authenticate(%{"email" => "teste@email.com"})
      assert {:error, "\"password\" is required"} == result
    end

    test "return email error when only password is passed" do
      UserFixture.user_fixture(%{email: "teste@email.com", password: "123123"})
      result = Session.authenticate(%{"password" => "123456"})
      assert {:error, "\"email\" is required"} == result
    end

    test "return error when password was leaked" do
      UserFixture.user_fixture(%{email: "teste@email.com", password: "123123"})
      result = Session.authenticate(%{"email" => "teste@email.com", "password" => ""})
      assert {:error, "\"password\" is not allowed to be empty"} == result
    end

    test "return error when email was leaked" do
      UserFixture.user_fixture(%{email: "teste@email.com", password: "123123"})
      result = Session.authenticate(%{"email" => "", "password" => "123123"})
      assert {:error, "\"email\" is not allowed to be empty"} == result
    end
  end
end
