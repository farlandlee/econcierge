defmodule Grid.ActivityControllerTest do
  use Grid.ConnCase

  alias Grid.Factory

  setup do
    {:ok, product: Factory.create(:product)}
  end

  test "POST /", %{conn: conn, product: p} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: p.activity_id})
    assert html_response(conn, 302) =~ "/activity/#{p.activity.slug}"
  end

  test "Get /<activity_slug>", %{conn: conn, product: p} do
    path = activity_path(conn, :show_by_slug, p.activity.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ p.activity.name
    assert response =~ p.vendor.name
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
end
