defmodule Grid.ExploreController do
  use Grid.Web, :controller

  if Grid.fetch_env!(:prerender_enabled) do
  plug Grid.Plugs.Prerender,
    service_url: Grid.fetch_env!(:prerender_service_url),
    service_token: Grid.fetch_env!(:prerender_service_token)
  end

  def index(conn, _) do
    conn
    |> put_layout(false)
    |> assign(:is_home, false)
    |> render("index.html")
  end

  def shared_cart(conn, params), do: index(conn, params)
end
