defmodule BlogApiWeb.Auth.Guardian do
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
    params
    |> case do
      %{"password" => _} ->
        _authenticate(params)

      %{"email" => _} ->
        _authenticate(params)

      _ ->
        cond do
          params["email"] == "" ->
            {:error, "\"email\" is not allowed to be empty"}

          params["password"] == "" ->
            {:error, "\"password\" is not allowed to be empty"}

          true ->
            case Session.authenticate(params["email"], params["password"]) do
              {:ok, user} ->
                create_token(user)

              {:error, message} ->
                {:error, message}
            end
        end
    end
  end

  def _authenticate(params) do
    case params do
      %{"email" => _} -> {:error, "\"password\" is required"}
      %{"password" => _} -> {:error, "\"email\" is required"}
    end
  end

  def is_email(email), do: Regex.match?(~r/@/, email) == true

  defp create_token(user) do
    {:ok, token, _claim} = encode_and_sign(user)
    {:ok, user, token}
  end
end
