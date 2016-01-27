defmodule Grid.ActivityControllerTest do
  use Grid.ConnCase

  alias Grid.Factory

  setup do
    e = Factory.create(:experience)
    c = Factory.create(:category, activity: e.activity)
    Factory.create(:experience_category, experience: e, category: c)

    p = Factory.create(:product, experience: e)

    {
      :ok,
      product: p,
      activity: e.activity,
      category: c
    }
  end

  test "POST with activity id, target vendors", %{conn: conn, activity: a} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: a.id, target: "vendors"})
    assert html_response(conn, 302) =~ "/browse/#{a.slug}/vendors"
  end

  test "POST with activity id, target experiences", %{conn: conn, activity: a} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: a.id, target: "experiences"})
    assert html_response(conn, 302) =~ "/browse/#{a.slug}/experiences"
  end

  test "POST with empty activity id", %{conn: conn} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: ""})
    assert html_response(conn, 302) =~ "/"
  end

  test "Get /browse/<activity_slug>/vendors", %{conn: conn, activity: a, product: p} do
    path = activity_path(conn, :vendors_by_activity_slug, a.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    assert response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">All</a>)
  end

  test "Get /browse/<activity_slug>/experiences", %{conn: conn, activity: a, product: p} do
    path = activity_path(conn, :experiences_by_activity_slug, a.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    assert response =~ p.experience.name
    assert response =~ ~s(<a class="active" href="#{path}">All</a>)
  end

  test "Get /browse/<activity_slug>/vendors doesn't show unpublished products", %{conn: conn, product: p, activity: a} do
    unpublish(p)

    path = activity_path(conn, :vendors_by_activity_slug, a.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    refute response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">All</a>)
    assert response =~ ~s(Sorry, no offerings for #{a.name} at this time.)
  end

  test "Get /browse/<activity_slug>/vendors only shows categories having published products", %{conn: conn, activity: a, category: c} do
    empty_category = Factory.create(:category)

    path = activity_path(conn, :vendors_by_activity_slug, a.slug)
    conn = get(conn, path)

    c_path = activity_path(conn, :vendors_by_activity_and_category_slugs, a.slug, c.slug)
    empty_category_path = activity_path(conn, :vendors_by_activity_and_category_slugs, a.slug, empty_category.slug)

    response = html_response(conn, 200)
    assert response =~ ~s(<a class="" href="#{c_path}">#{c.name}</a>)
    refute response =~ ~s(<a class="" href="#{empty_category_path}">#{empty_category.name}</a>)
  end

  test "Get /browse/<activity_slug>/<category_slug/vendors", %{conn: conn, product: p, activity: a, category: c} do
    path = activity_path(conn, :vendors_by_activity_and_category_slugs, a.slug, c.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    assert response =~ p.vendor.name
    assert response =~ ~s(<a class="active" href="#{path}">#{c.name}</a>)
  end

  test "Get /browse/<activity_slug>/<category_slug/experiences", %{conn: conn, product: p, activity: a, category: c} do
    path = activity_path(conn, :experiences_by_activity_and_category_slugs, a.slug, c.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    assert response =~ p.experience.name
    assert response =~ ~s(<a class="active" href="#{path}">#{c.name}</a>)
  end

  test "Get /browse/<activity_slug>/<category_slug/vendors doesn't show unpublished products", %{conn: conn, product: p, activity: a, category: c} do
    unpublish(p)

    path = activity_path(conn, :vendors_by_activity_and_category_slugs, a.slug, c.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    refute response =~ p.vendor.name
    refute response =~ ~s(<a class="active" href="#{path}">#{c.name}</a>)
  end

  test "Get /browse/<activity_slug>/<category_slug/experiences doesn't show unpublished products", %{conn: conn, product: p, activity: a, category: c} do
    unpublish(p)

    path = activity_path(conn, :experiences_by_activity_and_category_slugs, a.slug, c.slug)
    conn = get(conn, path)

    response = html_response(conn, 200)
    assert response =~ a.name
    refute response =~ p.experience.name
    refute response =~ ~s(<a class="active" href="#{path}">#{c.name}</a>)
  end

  defp unpublish(product) do
    from(p in Grid.Product,
      update: [set: [published: false]],
      where: p.id == ^product.id
    ) |> Repo.update_all([])
  end
end
