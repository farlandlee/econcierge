defmodule Grid.ActivityControllerTest do
  use Grid.ConnCase

  alias Grid.Factory

  setup do
    e = %{activity: activity}
      = Factory.create(:experience)

    i = Factory.create_activity_image(assoc_id: activity.id)

    Grid.Activity.changeset(activity, %{default_image_id: i.id})
    |> Repo.update!

    c = Factory.create(:category, activity: activity, image: i)
    Factory.create(:experience_category, experience: e, category: c)

    p = Factory.create(:product, experience: e)

    # Create a second category as to not trip the show redirect when only 1 category
    c2 = Factory.create(:category, activity: activity)
    Factory.create(:experience_category, experience: e, category: c2)

    {
      :ok,
      product: p,
      activity: activity,
      category: c,
      extra_cat: c2,
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

  test "GET show with image", %{conn: conn, activity: a, image: i} do
    conn = get(conn, activity_path(conn, :categories_by_activity_slug, a.slug))
    assert html_response(conn, 200) =~ i.original
  end

  test "GET index with image", %{conn: conn, image: i} do
    conn = get(conn, activity_path(conn, :index))
    assert html_response(conn, 200) =~ i.original
  end

  test "Get show with only one category redirects", %{conn: conn, activity: a, category: c, extra_cat: c2} do
    Repo.delete!(c2)
    conn = get(conn, activity_path(conn, :categories_by_activity_slug, a.slug))
    assert redirected_to(conn, 302) =~ explore_path(conn, :without_date, a.slug, c.slug)
  end

end
