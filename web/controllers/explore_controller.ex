defmodule Grid.ExploreController do
  use Grid.Web, :controller

  def index(conn, _) do
    conn
    |> put_layout(false)
    |> assign(:is_home, true)
    |> render
  end
end
