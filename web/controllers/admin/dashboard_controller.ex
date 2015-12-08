defmodule Grid.Admin.DashboardController do
  use Grid.Web, :controller

  def index(conn, _) do
    render conn, "index.html", page_title: "Admin Home"
  end
end
