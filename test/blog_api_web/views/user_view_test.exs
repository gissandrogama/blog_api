defmodule BlogApiWeb.UserViewTest do
  use ExUnit.Case, async: true

  alias BlogApiWeb.UserView

  test "render/2 returns index user" do
    users = [
      %{
        id: "1",
        display_name: "some displayName",
        email: "some@email.com",
        image: "some image",
        password: "some password_hash"
      }
    ]

    assert [
             %{
               id: "1",
               displayName: "some displayName",
               email: "some@email.com",
               image: "some image"
             }
           ] = UserView.render("index.json", %{users: users})
  end

  test "render/2 returns show user" do
    user = %{
      id: "1",
      display_name: "some displayName",
      email: "some@email.com",
      image: "some image",
      password: "some password_hash"
    }

    assert %{
             id: "1",
             displayName: "some displayName",
             email: "some@email.com",
             image: "some image"
           } = UserView.render("show.json", %{user: user})
  end
end
