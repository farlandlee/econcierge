defmodule Grid.PageController do
  use Grid.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
  def activities(conn, _params) do
    render conn, "activities.html"
  end
end
