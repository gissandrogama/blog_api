defmodule BlogApiWeb.PostView do
  use BlogApiWeb, :view
  alias BlogApiWeb.PostView

  def render("index.json", %{posts: posts}) do
    render_many(posts, PostView, "posts.json")
  end

  def render("show.json", %{post: post}) do
    render_one(post, PostView, "posts.json")
  end

  def render("create_show.json", %{post: post}) do
    render_one(post, PostView, "post.json")
  end

  def render("post.json", %{post: post}) do
    %{
      UserId: post.user_id,
      title: post.title,
      content: post.content
    }
  end

  def render("posts.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      content: post.content,
      user: %{
        id: post.user.id,
        displayName: post.user.display_name,
        email: post.user.email,
        image: post.user.image
      }
    }
  end
end
