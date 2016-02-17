defmodule Grid.ActivityControllerTest do
  use Grid.ConnCase

  alias Grid.Factory

  setup do
    e = Factory.create(:experience)
    i = Factory.create_activity_image(assoc_id: e.activity_id)
    c = Factory.create(:category, activity: e.activity, image: i)
    Factory.create(:experience_category, experience: e, category: c)

    p = Factory.create(:product, experience: e)

    {
      :ok,
      product: p,
      activity: e.activity,
      category: c,
      image: i
    }
  end

  test "POST with activity id, target vendors", %{conn: conn, activity: a} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: a.id, target: "vendors"})
    assert html_response(conn, 302) =~ "/browse/#{a.slug}/categories"
  end

  test "POST with activity id, target experiences", %{conn: conn, activity: a} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: a.id, target: "experiences"})
    assert html_response(conn, 302) =~ "/browse/#{a.slug}/categories"
  end

  test "POST with empty activity id", %{conn: conn} do
    conn = post(conn, activity_path(conn, :show), activity: %{id: ""})
    assert html_response(conn, 302) =~ "/"
  end

  test "GET index with image", %{conn: conn, activity: a, image: i} do
    conn = get(conn, activity_path(conn, :categories_by_activity_slug, a.slug))
    assert html_response(conn, 200) =~ i.original
  end
end
