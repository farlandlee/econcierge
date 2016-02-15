defmodule Grid.ErrorController do
  use Grid.Web, :controller

  def render_500(conn, _) do
    conn
    |> put_layout(false)
    |> render(Grid.ErrorView, "500.html")
  end

  def render_404(conn, _) do
    conn
    |> put_layout(false)
    |> render(Grid.ErrorView, "404.html")
  end
end
