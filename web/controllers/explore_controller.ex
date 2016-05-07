defmodule Grid.ExploreController do
  use Grid.Web, :controller

  plug Grid.Plugs.Prerender,
    service_url: Grid.fetch_env!(:prerender_service_url),
    service_token: Grid.fetch_env!(:prerender_service_token)

  def index(conn, _) do
    conn
    |> put_layout(false)
    |> assign(:is_home, false)
    |> render("index.html")
  end

  def shared_cart(conn, params), do: index(conn, params)

  def legacy_book_redirect(conn, %{"a_slug" => a_slug, "e_slug" => _, "p_id" => p_id}) do
    redirect(conn, to: explore_path(conn, :index, [a_slug, "experience", p_id]))
  end
  def legacy_book_redirect(conn, %{"a_slug" => a_slug, "p_id" => p_id}) do
    redirect(conn, to: explore_path(conn, :index, [a_slug, "experience", p_id]))
  end
end
