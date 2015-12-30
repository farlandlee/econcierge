defmodule Grid.PageController do
  use Grid.Web, :controller

  plug Grid.Plugs.AssignAvailableActivities

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
