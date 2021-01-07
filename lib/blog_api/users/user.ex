defmodule BlogApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :display_name, :string
    field :email, :string
    field :image, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:display_name, :email, :password_hash, :image])
    |> validate_required([:display_name, :email, :password_hash, :image])
  end
end
