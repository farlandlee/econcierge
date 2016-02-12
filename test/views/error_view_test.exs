defmodule Grid.ErrorViewTest do
  use Grid.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    rendered = render_to_string(Grid.ErrorView, "404.html", [])
    assert rendered =~ "Error Code: 404"
    assert rendered =~ "Oops! Looks like there's been a moose-take."
  end

  test "render 500.html" do
    rendered = render_to_string(Grid.ErrorView, "500.html", [])
    assert rendered =~ "Error Code: 500"
    assert rendered =~ "Something looks fishy."
  end

  test "render any other" do
    assert render_to_string(Grid.ErrorView, "505.html", []) =~
           "Error Code: 500"
  end
end
