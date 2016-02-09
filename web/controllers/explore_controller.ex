defmodule Grid.SearchController do
  use Grid.Web, :controller

  def index(conn, _) do
    conn
    |> put_resp_header("content-type", "text/html")
    |> send_file(200, "priv/static/explore/index.html")
  end
end
