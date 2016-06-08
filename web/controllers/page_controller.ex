defmodule Grid.PageController do
  use Grid.Web, :controller

  plug Grid.Plugs.AssignAvailableActivities

  def index(conn, _) do
    articles = Wordpress.load_concierge_articles()
    render(conn, "index.html", is_home: false, articles: articles)
  end
  def tou(conn, _), do: render(conn)

  def slideshow(conn = %{assigns: %{kiosk: _kiosk}}, _), do:
    render(conn, "slideshow.html", hide_purechat: true)
  def slideshow(conn, _), do: redirect(conn, to: page_path(conn, :index))
end
