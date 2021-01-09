defmodule BlogApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :display_name, :string
    field :email, :string, unique: true
    field :image, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:display_name, :email, :password, :image])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:display_name, :email, :password, :image])
    |> unique_constraint(:email, name: :users_email_index)
    |> validate_length(:display_name, min: 8)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/)
    |> update_change(:email, &String.downcase/1)
  end
end
