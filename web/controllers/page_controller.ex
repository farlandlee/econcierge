defmodule Grid.PageController do
  use Grid.Web, :controller

  plug Grid.Plugs.AssignAvailableActivities

  def index(conn, _), do: render(conn, "index.html", is_home: false)
  def tou(conn, _), do: render(conn)

  def slideshow(conn = %{assigns: %{kiosk: _kiosk}}, _), do:
    render(conn, "slideshow.html")
  def slideshow(conn, _), do: redirect(conn, to: page_path(conn, :index))
end
