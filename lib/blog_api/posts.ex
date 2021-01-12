defmodule BlogApi.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias BlogApi.Repo

  alias BlogApi.Posts.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def list_search(params) do
    search_term = get_in(params, ["q"])

    Post
    |> Post.search(search_term)
    |> Repo.all()
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> error_messages()
  end

  @doc """
  Updates a post.

  ## Examples

  iex> update_post(post, %{field: new_value})
  {:ok, %Post{}}

  iex> update_post(post, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

  iex> delete_post(post)
  {:ok, %Post{}}

  iex> delete_post(post)
  {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

  iex> change_post(post)
  %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  defp error_messages({:error, changeset}) when changeset.valid? == false do
    changeset = changeset.errors

    case changeset do
      [{:content, {"can't be blank", _}}, {:title, {"can't be blank", _}}] ->
        {:bad_request, %{message: " \"title\" and \"content\" is required"}}

      [{:title, {"can't be blank", [validation: :required]}}] ->
        {:bad_request, %{message: "\"title\" is required"}}

      [{:content, {"can't be blank", [validation: :required]}}] ->
        {:bad_request, %{message: "\"content\" is required"}}
    end
  end

  defp error_messages(changeset), do: changeset
end
