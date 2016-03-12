defmodule Grid.ExploreController do
  use Grid.Web, :controller

  plug Grid.Plugs.Prerender,
    service_url: Grid.fetch_env!(:prerender_service_url),
    service_token: Grid.fetch_env!(:prerender_service_token)

  def index(conn, _) do
    conn
    |> put_layout(false)
    |> assign(:is_home, true)
    |> render
  end
end
