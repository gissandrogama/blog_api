defmodule BlogApi.Users.Services.SearcheTest do
  use BlogApi.DataCase

  alias BlogApi.{PostFixture, Services.Search}

  describe "list_search/1" do
    test "return posts when the parameter is related to the title or content" do
      PostFixture.post_fixture(%{title: "This is title", content: "testing content"})
      result = Search.list_search(%{"q" => "This is"})

      assert [%BlogApi.Posts.Post{}] = result
    end

    test "return posts when the parameter is not related to the title or content" do
      PostFixture.post_fixture(%{title: "This is title", content: "testing content"})
      result = Search.list_search(%{"q" => "Primeiro post"})

      assert [] = result
    end
  end
end
