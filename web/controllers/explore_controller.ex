defmodule Grid.ExploreController do
  use Grid.Web, :controller

  def index(conn, _) do
    conn
    |> put_layout(false)
    |> render
  end
end
