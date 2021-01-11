defmodule BlogApi.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogApi.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :content, :string
    field :title, :string
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_title()
    |> validate_content()
  end

  defp validate_title(changeset) do
    changeset
    |> validate_required([:title], message: "\"title\" is required")
  end

  defp validate_content(changeset) do
    changeset
    |> validate_required([:content], message: "\"content\" is required")
  end
end
