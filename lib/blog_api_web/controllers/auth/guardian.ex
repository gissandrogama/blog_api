defmodule BlogApiWeb.Auth.Guardian do
  @moduledoc """
  has functions that authenticate a user and generate token
  """
  use Guardian, otp_app: :blog_api

  alias BlogApi.Services.Session

  def subject_for_token(user, _claims), do: {:ok, to_string(user.id)}

  def resource_from_claims(claims) do
    user =
      claims["sub"]
      |> BlogApi.Users.get_user!()

    {:ok, user}
  end

  def authenticate(params) do
    case Session.authenticate(params) do
      {:ok, user} ->
        create_token(user)

      {:error, message} ->
        {:error, message}
    end
  end

  defp create_token(user) do
    {:ok, token, _claim} = encode_and_sign(user)
    {:ok, user, token}
  end
end
