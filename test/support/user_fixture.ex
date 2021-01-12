defmodule BlogApi.UserFixture do
  @moduledoc """
  module that has simple functions to generate test parameters that need a user
  """

  alias BlogApi.Users

  def displayName(), do: "some displayName"
  def email(), do: "some#{System.unique_integer()}@email.com"
  def image(), do: "some image"
  def password(), do: "123456"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        display_name: displayName(),
        email: email(),
        image: image(),
        password: password()
      })
      |> Users.create_user()

    user
  end
end
