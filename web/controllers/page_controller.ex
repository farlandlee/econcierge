defmodule Grid.PageController do
  use Grid.Web, :controller

  plug Grid.Plugs.AssignAvailableActivities

  def index(conn, _), do: render(conn, "index.html", is_home: false)
  def tou(conn, _), do: render(conn)
end
