defmodule Grid.Admin.Vendor.ProductImageControllerTest do
  use Grid.ConnCase

  alias Grid.Image
  alias Grid.Product

  @valid_attrs %{"alt" => "New caption"}
  @invalid_attrs %{filename: nil}

  @table {"product_images", Image}

  setup do
    p = Factory.create(:product)
    i = Factory.create_product_image(assoc_id: p.id)

    {:ok, product: p, image: i}
  end

  test "Index redirects to product", %{conn: conn, product: product} do
    conn = get conn, admin_vendor_product_image_path(conn, :index, product.vendor, product)
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, product.vendor, product, tab: "images")
  end

  test "set default image", %{conn: conn, product: p, image: i} do
    conn = put conn, admin_vendor_product_image_path(conn, :set_default, p.vendor, p, i)
    assert redirected_to(conn) =~ admin_vendor_product_path(conn, :show, p.vendor, p, tab: "images")

    conn = conn |> recycle_with_auth |> get(admin_vendor_product_path(conn, :show, p.vendor, p, tab: "images"))
    assert html_response(conn, 200) =~ "Current default"

    p = Repo.get!(Product, p.id)
    assert p.default_image_id == i.id
  end

  test "renders form for new resources", %{conn: conn, product: p} do
    conn = get conn, admin_vendor_product_image_path(conn, :new, p.vendor, p)
    assert html_response(conn, 200) =~ "Add Image for #{p.name}"
    assert html_response(conn, 200) =~ "Caption"
    assert html_response(conn, 200) =~ "Choose A File to Upload"
  end

  # @TODO how do we spoof file upload?
  # test "creates resource and redirects when data is valid", %{conn: conn, product: p} do
  #   conn = post conn, admin_vendor_product_image_path(conn, :create, p.vendor, p), image: @valid_attrs
  #   assert redirected_to(conn) == admin_vendor_product_path(conn, :show, p.vendor, p)
  # end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, product: p} do
    conn = post conn, admin_vendor_product_image_path(conn, :create, p.vendor, p), image: @invalid_attrs
    assert html_response(conn, 200) =~ "New Product Image"
  end

  test "shows chosen resource", %{conn: conn, product: p, image: i} do
    conn = get conn, admin_vendor_product_image_path(conn, :show, p.vendor, p, i)
    assert html_response(conn, 200) =~ "#{i.filename}"
    assert html_response(conn, 200) =~ "#{i.alt}"
    assert html_response(conn, 200) =~ "#{i.original}"
    assert html_response(conn, 200) =~ "#{i.medium}"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, product: p} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_vendor_product_image_path(conn, :show, p.vendor, p, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, product: p, image: i} do
    conn = get conn, admin_vendor_product_image_path(conn, :edit, p.vendor, p, i)
    assert html_response(conn, 200) =~ "Edit Product Image"
    assert html_response(conn, 200) =~ "Caption"
    refute html_response(conn, 200) =~ "Choose A File to Upload"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, product: p, image: i} do
    conn = put conn, admin_vendor_product_image_path(conn, :update, p.vendor, p, i), image: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_image_path(conn, :show, p.vendor, p, i)

    conn = conn |> recycle_with_auth |> get(admin_vendor_product_image_path(conn, :show, p.vendor, p, i))
    assert html_response(conn, 200) =~ @valid_attrs["alt"]

    assert Repo.get_by(@table, %{alt: @valid_attrs["alt"]})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, product: p, image: i} do
    conn = put conn, admin_vendor_product_image_path(conn, :update, p.vendor, p, i), image: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Product Image"
  end

  test "deletes chosen image and its intersect entity", %{conn: conn, product: p, image: i} do
    conn = delete conn, admin_vendor_product_image_path(conn, :delete, p.vendor, p, i)
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, p.vendor, p, tab: "images")
    refute Repo.get(@table, i.id)
  end
end
