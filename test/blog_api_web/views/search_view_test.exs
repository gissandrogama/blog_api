defmodule BlogApiWeb.SearchViewTest do
  use ExUnit.Case, async: true

  alias BlogApiWeb.SearchView

  # %BlogApi.Posts.Post{
  #   __meta__: #Ecto.Schema.Metadata<:loaded, "posts">,
  #   content: "Esse é o primeiro post",
  #   id: "2cf3e23c-feed-40ab-b924-d586e5147c9b",
  #   inserted_at: ~N[2021-01-13 01:47:34],
  #   title: "Primeiro post",
  #   updated_at: ~N[2021-01-13 01:47:34],
  #   user: #Ecto.Association.NotLoaded<association :user is not loaded>,
  #   user_id: "6aec4558-b36f-4a1a-8bdf-959412eb300c"
  # }

  test "render/2 returns index user" do
    searchs = [
      %{
        id: "1",
        title: "Title of post",
        content: "Content do post",
        inserted_at: ~N[2021-01-13 01:47:34],
        updated_at: ~N[2021-01-13 01:47:34],
        user: %{
          id: "2",
          display_name: "Teste Sila",
          email: "testesilva@email.com",
          image: "image url"
        },
        user_id: "6aec4558-b36f-4a1a-8bdf-959412eb300c"
      }
    ]

    assert [
             %{
               id: "1",
               title: "Title of post",
               content: "Content do post",
               user: %{
                 id: "2",
                 displayName: "Teste Sila",
                 email: "testesilva@email.com",
                 image: "image url"
               }
             }
           ] = SearchView.render("show.json", %{searchs: searchs})
  end
end
