defmodule Grid.ErrorView do
  use Grid.Web, :view

  def render("404.json", _assigns) do
    %{errors: [%{status: 404, message: "Not found"}]}
  end

  def render("404.html", assigns) do
    render("not_found.html", assigns)
  end

  def render("500.json", _assigns) do
    %{errors: [%{status: 500, message: "Server error"}]}
  end

  def render("500.html", assigns) do
    render("server_error.html", assigns)
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
