defmodule BlogApi.Users.User do
  @moduledoc """
  module that has user parameter validation function.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogApi.Posts.Post

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :display_name, :string
    field :email, :string, unique: true
    field :image, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:display_name, :email, :password, :image])
    |> validate_email()
    |> validate_password()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_length(:display_name, min: 8)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/)
    |> update_change(:email, &String.downcase/1)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> hashing()
  end

  defp hashing(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hashing(changeset), do: changeset
end
