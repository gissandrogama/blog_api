defmodule BlogApiWeb.SearchView do
  use BlogApiWeb, :view
  alias BlogApiWeb.PostView

  def render("show.json", %{posts: posts}) do
    render_many(posts, PostView, "post.json")
  end

  def render("post.json", %{post: post}) do
    %{
      Id: post.id,
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
