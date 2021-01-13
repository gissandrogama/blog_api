defmodule BlogApiWeb.SessionViewTest do
  use ExUnit.Case, async: true

  alias BlogApiWeb.SessionView

  test "render/2 returns show token" do
    token = "alksjdaksjfklasdjfklasdjfksakjflkasjfksda"

    assert %{token: "alksjdaksjfklasdjfklasdjfksakjflkasjfksda"} =
             SessionView.render("show.json", %{token: token})
  end
end
