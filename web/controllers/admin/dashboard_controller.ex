defmodule Grid.Admin.DashboardController do
  use Grid.Web, :controller
  plug Grid.Plugs.PageTitle, title: "Dashboard"

  def index(conn, _) do
    render conn, "index.html", page_title: "Dashboard"
  end
end
