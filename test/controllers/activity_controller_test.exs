defmodule Grid.ActivityControllerTest do
  use Grid.ConnCase

  alias Grid.Factory

  import Ecto.Query

  setup do
    {:ok, product: Factory.create(:product)}
  end

  test "POST /", %{conn: conn, product: p} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: p.activity_id})
    assert html_response(conn, 302) =~ "/activity/#{p.activity.slug}"
  end

  test "POST with empty activity id", %{conn: conn, product: p} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: ""})
    assert html_response(conn, 302) =~ "/"
  end

  test "Get /<activity_slug>", %{conn: conn, product: p} do
    path = activity_path(conn, :show_by_slug, p.activity.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ p.activity.name
    assert response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">All</a>)
  end

  test "Get /<activity_slug> doesn't show unpublished products", %{conn: conn, product: p} do
    unpublish(p)

    path = activity_path(conn, :show_by_slug, p.activity.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ p.activity.name
    refute response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">All</a>)
  end


  test "Get /<activity_name>/<category_name>", %{conn: conn, product: p} do
    Factory.with_activity_category(p)
    a = p.activity |> Repo.preload(:categories)
    c = hd(a.categories)
    path = activity_path(conn, :show_by_slug_and_category, p.activity.slug, c.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ p.activity.name
    assert response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">#{c.name}</a>)
  end

  test "Get /<activity_name>/<category_name> doesn't show unpublished products", %{conn: conn, product: p} do
    Factory.with_activity_category(p)
    a = p.activity |> Repo.preload(:categories)
    c = hd(a.categories)

    unpublish(p)

    path = activity_path(conn, :show_by_slug_and_category, p.activity.slug, c.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ p.activity.name
    refute response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">#{c.name}</a>)
  end

  defp unpublish(product) do
    from(p in Grid.Product,
      update: [set: [published: false]],
      where: p.id == ^product.id
    ) |> Repo.update_all([])
  end
end
