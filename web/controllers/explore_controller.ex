defmodule Grid.ExploreController do
  use Grid.Web, :controller
  def index(conn, _) do
    conn
    |> put_layout(false)
    |> put_resp_header("content-type", "text/html")
    |> render
  end
end
