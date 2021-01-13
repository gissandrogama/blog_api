defmodule BlogApiWeb.PostViewTest do
  use ExUnit.Case, async: true

  alias BlogApiWeb.PostView

  test "render/2 returns create_show post" do
    post = %{
      user_id: "34",
      title: "Primeiro post",
      content: "Esse é o primeiro post"
    }

    assert %{
             UserId: "34",
             title: "Primeiro post",
             content: "Esse é o primeiro post"
           } = PostView.render("create_show.json", %{post: post})
  end

  test "render/2 returns index posts" do
    posts = [
      %{
        id: "1",
        title: "Primeiro post",
        content: "Esse é o primeiro post",
        user: %{
          id: "2",
          display_name: "Henry Gama",
          email: "henry@gmail.com",
          image: "string"
        }
      }
    ]

    assert [
             %{
               id: "1",
               title: "Primeiro post",
               content: "Esse é o primeiro post",
               user: %{
                 id: "2",
                 displayName: "Henry Gama",
                 email: "henry@gmail.com",
                 image: "string"
               }
             }
           ] = PostView.render("index.json", %{posts: posts})
  end

  test "render/2 returns show post" do
    post = %{
      id: "3",
      title: "Primeiro post",
      content: "Esse é o primeiro post",
      user: %{
        id: "4",
        display_name: "Henry Gama",
        email: "henry@gmail.com",
        image: "string"
      }
    }

    assert %{
             id: "3",
             title: "Primeiro post",
             content: "Esse é o primeiro post",
             user: %{
               displayName: "Henry Gama",
               email: "henry@gmail.com",
               id: "4",
               image: "string"
             }
           } = PostView.render("show.json", %{post: post})
  end
end
