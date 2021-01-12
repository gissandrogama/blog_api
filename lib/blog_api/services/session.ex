defmodule BlogApi.Services.Session do
  @moduledoc """
  includes functions that verify that a user exists by email and that the password
  matches the user.
  """
  alias BlogApi.{Repo, Users.User}

  @doc """
  Function that searches for a user and buys the password

  ## Examples user not exist

      iex> authenticate(%{"email" => "test@test.com", "password" => "132456"})
      {:error, "Campos inválidos"}
  """
  def authenticate(params) do
    case validate_params(params) do
      {:error, msg} ->
        {:error, msg}

      %{"email" => email, "password" => password} ->
        verify_user(email, password)
    end
  end

  @doc """
  Function validates the passed parameters

  ## if only email is passed

      iex> authenticate(%{"email" => "test@test.com"})
       {:error, "\"email\" is required"}
  """
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

  defp verify_user(email, password) do
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
