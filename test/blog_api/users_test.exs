defmodule BlogApi.UsersTest do
  use BlogApi.DataCase

  import BlogApi.UserFixture

  alias BlogApi.Users

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

  describe "users" do
    alias BlogApi.Users.User

    test "list_users/0 returns all users" do
      user_fixture()
      assert Users.list_users() |> Enum.count() == 1
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id).display_name == user.display_name
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_user)
      assert user.display_name == "some displayName"
      assert user.email == "some@email.com"
      assert user.image == "some image"
      assert user.password == "123456"
    end

    test "create_user/1 with invalid data returns error changeset" do
      response = Users.create_user(@invalid_user)
      assert {:bad_request, %{message: " \"email\" and \"password\" is required"}} = response
    end

    test "create_user/0 with invalid data returns error changeset" do
      response = Users.create_user()
      assert {:bad_request, %{message: " \"email\" and \"password\" is required"}} = response
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Users.update_user(user, @update_user)
      assert user.display_name == "some updated display_name"
      assert user.email == "some_updated@email.com"
      assert user.image == "some updated image"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:bad_request, %{message: " \"email\" and \"password\" is required"}} = Users.update_user(user, @invalid_user)
      assert user.email == Users.get_user!(user.id).email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert {:not_found, "Usuário não existe"} == Users.get_user!(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end

  describe "displayName validation tests" do
    test "when displayName is less than 8 characters" do
      response =
        Users.create_user(%{
          display_name: "some",
          email: "some@email.com",
          image: "some image",
          password: "123456"
        })

      assert {:bad_request,
              %{message: "\"displayName\" length must be at least 8 characters long"}} = response
    end
  end

  describe "password validation tests" do
    test "when password is less than 6 characters" do
      response =
        Users.create_user(%{
          display_name: "some displayName",
          email: "some@email.com",
          image: "some image",
          password: "12345"
        })

      assert {:bad_request, %{message: "\"password\" length must be 6 characters long"}} =
               response
    end

    test "when password not passed" do
      response =
        Users.create_user(%{
          display_name: "some displayName",
          email: "some@email.com",
          image: "some image",
          password: ""
        })

      assert {:bad_request, %{message: "\"password\" is required"}} = response
    end
  end

  describe "email validation tests" do
    test "when email is spent without the domain" do
      response =
        Users.create_user(%{
          display_name: "some displayName",
          email: "some@",
          image: "some image",
          password: "123456"
        })

      assert {:bad_request, %{message: "\"email\" must be a valid email"}} = response
    end

    test "when email is passed only with the domain" do
      response =
        Users.create_user(%{
          display_name: "some displayName",
          email: "@email.com",
          image: "some image",
          password: "123456"
        })

      assert {:bad_request, %{message: "\"email\" must be a valid email"}} = response
    end

    test "when email is passed without the '@'" do
      response =
        Users.create_user(%{
          display_name: "some displayName",
          email: "somedisplayName",
          image: "some image",
          password: "123456"
        })

      assert {:bad_request, %{message: "\"email\" must be a valid email"}} = response
    end

    test "when email not passed" do
      response =
        Users.create_user(%{
          display_name: "some displayName",
          image: "some image",
          password: "123456"
        })

      assert {:bad_request, %{message: "\"email\" is required"}} = response
    end
  end
end
