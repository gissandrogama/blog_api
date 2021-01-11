defmodule BlogApi.Services.Session do
  alias BlogApi.Users.User
  alias BlogApi.Repo

  def authenticate(params) do
    case validate_params(params) do
      {:error, msg} ->
        {:error, msg}

      %{"email" => email, "password" => password} ->
        case Repo.get_by(User, email: email) do
          nil ->
            {:error, "Campos inválidos"}

          user ->
            if Argon2.verify_pass(password, user.password_hash) do
              {:ok, user}
            else
              {:error, "password inválido"}
            end
        end
    end
  end

  def validate_params(params) do
    cond do
      Map.fetch(params, "email") == :error ->
        {:error, "\"email\" is required"}

      Map.fetch(params, "password") == :error ->
        {:error, "\"password\" is required"}

      params["email"] == "" ->
        {:error, "\"email\" is not allowed to be empty"}

      params["password"] == "" ->
        {:error, "\"password\" is not allowed to be empty"}

      true ->
        params
    end
  end
end
