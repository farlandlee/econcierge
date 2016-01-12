defmodule Grid.Admin.Activity.ImageControllerTest do
  use Grid.ConnCase

  alias Grid.Image
  alias Grid.Activity

  @valid_attrs %{"alt" => "New caption"}
  @invalid_attrs %{}

  @table {"activity_images", Image}

  setup do
    a = Factory.create(:activity)
    i = Factory.create_activity_image(assoc_id: a.id)

    {:ok, activity: a, image: i}
  end

  test "set default image", %{conn: conn, activity: a, image: i} do
    conn = put conn, admin_activity_image_path(conn, :set_default, a, i)
    assert redirected_to(conn) =~ admin_activity_path(conn, :show, a)

    conn = recycle(conn)
    conn = get conn, admin_activity_path(conn, :show, a)
    assert html_response(conn, 200) =~ "Current default"

    a = Repo.get!(Activity, a.id)
    assert a.default_image_id == i.id
  end

  test "renders form for new resources", %{conn: conn, activity: a} do
    conn = get conn, admin_activity_image_path(conn, :new, a.id)
    assert html_response(conn, 200) =~ "New Activity Image"
    assert html_response(conn, 200) =~ "Caption"
    assert html_response(conn, 200) =~ "Choose A File to Upload"
  end

#@TODO how do we spoof file upload?
  # test "creates resource and redirects when data is valid", %{conn: conn, activity: a} do
  #   conn = post conn, admin_activity_image_path(conn, :create, a.id), image: @valid_attrs
  #   assert redirected_to(conn) == admin_activity_path(conn, :show, a.id)
  # end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, activity: a} do
    conn = post conn, admin_activity_image_path(conn, :create, a), image: @invalid_attrs
    assert html_response(conn, 200) =~ "New Activity Image"
  end

  test "shows chosen resource", %{conn: conn, activity: a, image: i} do
    conn = get conn, admin_activity_image_path(conn, :show, a, i)
    assert html_response(conn, 200) =~ "#{i.filename}"
    assert html_response(conn, 200) =~ "#{i.alt}"
    assert html_response(conn, 200) =~ "#{i.original}"
    assert html_response(conn, 200) =~ "#{i.medium}"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, activity: a} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_activity_image_path(conn, :show, a, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, activity: a, image: i} do
    conn = get conn, admin_activity_image_path(conn, :edit, a, i)
    assert html_response(conn, 200) =~ "Edit Activity Image"
    assert html_response(conn, 200) =~ "Caption"
    refute html_response(conn, 200) =~ "Choose A File to Upload"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, activity: a, image: i} do
    conn = put conn, admin_activity_image_path(conn, :update, a, i), image: @valid_attrs
    assert redirected_to(conn) == admin_activity_image_path(conn, :show, a, i)

    conn = recycle(conn)
    conn = get conn, admin_activity_image_path(conn, :show, a, i)
    assert html_response(conn, 200) =~ @valid_attrs["alt"]

    assert Repo.get_by(@table, %{alt: @valid_attrs["alt"]})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, activity: a, image: i} do
    conn = put conn, admin_activity_image_path(conn, :update, a, i), image: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Activity Image"
  end

  test "deletes chosen image and its intersect entity", %{conn: conn, activity: a, image: i} do
    conn = delete conn, admin_activity_image_path(conn, :delete, a, i)
    assert redirected_to(conn) == admin_activity_path(conn, :show, a)
    refute Repo.get(@table, i.id)
  end
end
