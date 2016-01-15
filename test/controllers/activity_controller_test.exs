defmodule Grid.ActivityControllerTest do
  use Grid.ConnCase

  alias Grid.Factory

  setup do
    e = Factory.create(:experience)
    ec = Factory.create(:experience_category, experience: e)

    p = Factory.create(:product, experience: e)

    {
      :ok,
      product: p,
      activity: e.activity,
      category: ec.category
    }
  end

  test "POST /", %{conn: conn, activity: a} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: a.id})
    assert html_response(conn, 302) =~ "/activity/#{a.slug}"
  end

  test "POST with empty activity id", %{conn: conn} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: ""})
    assert html_response(conn, 302) =~ "/"
  end

  test "Get /<activity_slug>", %{conn: conn, activity: a, product: p} do
    path = activity_path(conn, :show_by_slug, a.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    assert response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">All</a>)
  end

  test "Get /<activity_slug> doesn't show unpublished products", %{conn: conn, product: p, activity: a} do
    unpublish(p)

    path = activity_path(conn, :show_by_slug, a.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    refute response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">All</a>)
    assert response =~ ~s(Sorry, no offerings for #{a.name} at this time.)
  end

  test "Get /<activity_slug> only shows categories having published products", %{conn: conn, activity: a, category: c} do
    empty_category = Factory.create(:category)

    path = activity_path(conn, :show_by_slug, a.slug)
    conn = get(conn, path)

    c_path = activity_path(conn, :show_by_slug_and_category, a.slug, c.slug)
    empty_category_path = activity_path(conn, :show_by_slug_and_category, a.slug, empty_category.slug)

    response = html_response(conn, 200)
    assert response =~ ~s(<a class="" href="#{c_path}">#{c.name}</a>)
    refute response =~ ~s(<a class="" href="#{empty_category_path}">#{empty_category.name}</a>)
  end

  test "Get /<activity_name>/<category_name>", %{conn: conn, product: p, activity: a, category: c} do
    path = activity_path(conn, :show_by_slug_and_category, a.slug, c.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    assert response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">#{c.name}</a>)
  end

  test "Get /<activity_name>/<category_name> doesn't show unpublished products", %{conn: conn, product: p, activity: a, category: c} do
    unpublish(p)

    path = activity_path(conn, :show_by_slug_and_category, a.slug, c.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    refute response =~ p.vendor.name
    refute response =~ ~s(<a class="active" href="#{path}">#{c.name}</a>)
  end

  defp unpublish(product) do
    from(p in Grid.Product,
      update: [set: [published: false]],
      where: p.id == ^product.id
    ) |> Repo.update_all([])
  end
end
