defmodule BlogApi.PostFixture do
  @moduledoc """
  module that has simple functions to generate test parameters that need a user
  """

  alias BlogApi.{Posts, UserFixture}

  def title, do: "some title"
  def content, do: "some content"
  def user_id, do: UserFixture.user_fixture()

  def post_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        title: title(),
        content: content(),
        user_id: user_id().id
      })
      |> Posts.create_post()

    user
  end
end
