defmodule Grid.Admin.VendorImageControllerTest do
  use Grid.ConnCase

  alias Grid.Image
  alias Grid.Vendor

  @valid_attrs %{"alt" => "New caption"}
  @invalid_attrs %{}

  @table {"vendor_images", Image}

  setup do
    v = Factory.create(:vendor)
    i = Factory.create_vendor_image(assoc_id: v.id)

    {:ok, vendor: v, image: i}
  end

  test "Index redirects to vendor", %{conn: conn, vendor: vendor} do
    conn = get conn, admin_vendor_image_path(conn, :index, vendor)
    assert redirected_to(conn) == admin_vendor_path(conn, :show, vendor)
  end

  test "set default image", %{conn: conn, vendor: v, image: i} do
    conn = put conn, admin_vendor_image_path(conn, :set_default, v, i)
    assert redirected_to(conn) =~ admin_vendor_path(conn, :show, v)

    conn = conn |> recycle_with_auth |> get(admin_vendor_path(conn, :show, v))
    assert html_response(conn, 200) =~ "Current default"

    v = Repo.get!(Vendor, v.id)
    assert v.default_image_id == i.id
  end

  test "renders form for new resources", %{conn: conn, vendor: v} do
    conn = get conn, admin_vendor_image_path(conn, :new, v)
    assert html_response(conn, 200) =~ "Add Image for #{v.name}"
    assert html_response(conn, 200) =~ "Caption"
    assert html_response(conn, 200) =~ "Choose A File to Upload"
  end

#@TODO how do we spoof file upload?
  # test "creates resource and redirects when data is valid", %{conn: conn, vendor: v} do
  #   conn = post conn, admin_vendor_image_path(conn, :create, v.id), image: @valid_attrs
  #   assert redirected_to(conn) == admin_vendor_path(conn, :show, v.id)
  # end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, vendor: v} do
    conn = post conn, admin_vendor_image_path(conn, :create, v), image: @invalid_attrs
    assert html_response(conn, 200) =~ "New Vendor Image"
  end

  test "shows chosen resource", %{conn: conn, vendor: v, image: i} do
    conn = get conn, admin_vendor_image_path(conn, :show, v, i)
    assert html_response(conn, 200) =~ "#{i.filename}"
    assert html_response(conn, 200) =~ "#{i.alt}"
    assert html_response(conn, 200) =~ "#{i.original}"
    assert html_response(conn, 200) =~ "#{i.medium}"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, vendor: v} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_vendor_image_path(conn, :show, v, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: v, image: i} do
    conn = get conn, admin_vendor_image_path(conn, :edit, v, i)
    assert html_response(conn, 200) =~ "Edit Vendor Image"
    assert html_response(conn, 200) =~ "Caption"
    refute html_response(conn, 200) =~ "Choose A File to Upload"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: v, image: i} do
    conn = put conn, admin_vendor_image_path(conn, :update, v, i), image: @valid_attrs
    assert redirected_to(conn) == admin_vendor_image_path(conn, :show, v, i)

    conn = conn |> recycle_with_auth |> get(admin_vendor_image_path(conn, :show, v, i))
    assert html_response(conn, 200) =~ @valid_attrs["alt"]

    assert Repo.get_by(@table, %{alt: @valid_attrs["alt"]})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: v, image: i} do
    conn = put conn, admin_vendor_image_path(conn, :update, v, i), image: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Vendor Image"
  end

  test "deletes chosen image and its intersect entity", %{conn: conn, vendor: v, image: i} do
    conn = delete conn, admin_vendor_image_path(conn, :delete, v, i)
    assert redirected_to(conn) == admin_vendor_path(conn, :show, v)
    refute Repo.get(@table, i.id)
  end
end
