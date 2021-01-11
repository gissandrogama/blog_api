defmodule BlogApi.Services.Session do
  alias BlogApi.Users.User
  alias BlogApi.Repo

  def authenticate(email, password) do
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
