defmodule BlogApi.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

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
    |> validate_required([:title])
  end

  defp validate_content(changeset) do
    changeset
    |> validate_required([:content])
  end

  def search(query, search_term) do
    post_search = "%#{search_term}%"

    from post in query,
    where: ilike(post.title, ^post_search),
    or_where: ilike(post.content, ^post_search)
  end
end
