defmodule Grid.ActivityControllerTest do
  use Grid.ConnCase

  alias Grid.Factory

  setup do
    {:ok, conn: conn(), product: Factory.create(:product)}
  end

  test "POST /", %{conn: conn, product: p} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: p.activity_id})
    assert html_response(conn, 302) =~ "/activity/#{p.activity.slug}"
  end

  test "Get /<activity_slug>", %{conn: conn, product: p} do
    conn = get(conn, activity_path(conn, :show_by_slug, p.activity.slug))
    response = html_response(conn, 200)
    assert response =~ p.activity.name
    assert response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="/activity/#{p.activity.slug}">All</a>)
  end

  test "Get /<activity_name>/<category_name>", %{conn: conn, product: p} do
    Factory.with_activity_category(p)
    a = p.activity |> Repo.preload(:categories)
    c = hd(a.categories)

    conn = get(conn, activity_path(conn, :show_by_slug_and_category, p.activity.slug, c.slug))
    response = html_response(conn, 200)
    assert response =~ p.activity.name
    assert response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="/activity/#{p.activity.slug}/#{c.slug}">#{c.name}</a>)
  end
end
