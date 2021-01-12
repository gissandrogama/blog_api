defmodule BlogApi.UserFixture do
  @moduledoc """
  module that has simple functions to generate test parameters that need a user
  """
  def valid_user,
    do: %{
      display_name: "some displayName",
      email: "some@email.com",
      image: "some image",
      password: "some password_hash"
    }

  def update_user,
    do: %{
      display_name: "some updated display_name",
      email: "some_updated@email.com",
      image: "some updated image",
      password: "some updated password_hash"
    }

  def invalid_user, do: %{display_name: nil, email: nil, image: nil, password_hash: nil}
end
