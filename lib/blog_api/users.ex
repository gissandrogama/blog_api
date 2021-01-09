defmodule BlogApi.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias BlogApi.Repo

  alias BlogApi.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> error_messages()
  end

  defp error_messages({:error, changeset}) when changeset.valid? == false do
    changeset = changeset.errors
    
    case changeset do
      [{:email, {_, [constraint: :unique, constraint_name: "users_email_index"]}}] ->
        {:conflict, %{message: "Usuário já existe"}}

      [{:email, {"has invalid format", [validation: :format]}}] ->
        {:bad_request, %{message: "\"email\" must be a valid email"}}

      [{:email, {"can't be blank", [validation: :required]}}] ->
        {:bad_request, %{message: "\"email\" is required"}}

      [
        {:display_name,
         {"should be at least %{count} character(s)",
          [count: 8, validation: :length, kind: :min, type: :string]}}
      ] ->
        {:bad_request, %{message: "\"displayName\" length must be at least 8 characters long"}}
    end
  end

  defp error_messages(changeset), do: changeset

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
