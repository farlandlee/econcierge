defmodule Grid.PageController do
  use Grid.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
