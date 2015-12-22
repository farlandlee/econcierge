defmodule Grid.Admin.ImageControllerTest do
  use Grid.ConnCase

  alias Grid.Image
  alias Grid.Vendor

  import Ecto.Model, only: [build: 2]

  @valid_attrs %{"alt" => "New caption"}
  @invalid_attrs %{}

  @table {"vendor_images", Image}
  @vendor %Vendor{name: "ImageVendorTest", description: "ImageVendorTestVendor"}
  @image_params %{filename: "filename.jpg", alt: "Some alt text", medium: "/priv/test/foobar.jpg", original: "/priv/test/original-foobar.jpg"}

  defp build_image(vendor, fields) do
    build(vendor, :images)
    |> Map.merge(fields)
  end
  setup do
    v = Repo.insert!(@vendor)
    i = build_image(v, @image_params) |> Repo.insert!


    conn = conn()

    on_exit fn ->
      for model <- [v, i] do
        try do
          Repo.delete(model)
        rescue
          Ecto.StaleModelError -> :ok
        end
      end
    end
    {:ok, conn: conn, vendor: v, image: i}
  end

  test "lists all entries on index", %{conn: conn, vendor: v, image: i} do
    no_alt_img = build_image(v, %{filename: "no_alt.jpg"}) |> Repo.insert!

    conn = get conn, admin_vendor_image_path(conn, :index, v.id)
    response = html_response(conn, 200)
    assert response =~ "#{v.name} Images"
    assert response =~ "#{i.filename}"
    assert response =~ "#{i.alt}"
    assert response =~ "Set as Default"

    assert response =~ "#{no_alt_img.filename}"
    assert response =~ "No caption"

    Repo.delete!(no_alt_img)
  end

  test "set default image", %{conn: conn, vendor: v, image: i} do
    conn = put conn, admin_vendor_image_path(conn, :set_default, v.id, i.id)
    assert redirected_to(conn) =~ admin_vendor_image_path(conn, :index, v.id)

    conn = recycle(conn)
    conn = get conn, admin_vendor_image_path(conn, :index, v.id)
    assert html_response(conn, 200) =~ "Current default"

    v = Repo.get!(Vendor, v.id)
    assert v.default_image_id == i.id
  end

  test "renders form for new resources", %{conn: conn, vendor: v} do
    conn = get conn, admin_vendor_image_path(conn, :new, v.id)
    assert html_response(conn, 200) =~ "Add image for #{v.name}"
    assert html_response(conn, 200) =~ "Caption"
    assert html_response(conn, 200) =~ "Choose A File to Upload"
  end

#@TODO how do we spoof file upload?
  # test "creates resource and redirects when data is valid", %{conn: conn, vendor: v} do
  #   conn = post conn, admin_vendor_image_path(conn, :create, v.id), image: @valid_attrs
  #   assert redirected_to(conn) == admin_vendor_image_path(conn, :index, v.id)
  # end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, vendor: v} do
    conn = post conn, admin_vendor_image_path(conn, :create, v.id), image: @invalid_attrs
    assert html_response(conn, 200) =~ "Add image for #{v.name}"
  end

  test "shows chosen resource", %{conn: conn, vendor: v, image: i} do
    conn = get conn, admin_vendor_image_path(conn, :show, v.id, i.id)
    assert html_response(conn, 200) =~ "#{i.filename} | #{v.name}"
    assert html_response(conn, 200) =~ "#{i.alt}"
    assert html_response(conn, 200) =~ "#{i.original}"
    assert html_response(conn, 200) =~ "#{i.medium}"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, vendor: v} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_vendor_image_path(conn, :show, v.id, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: v, image: i} do
    conn = get conn, admin_vendor_image_path(conn, :edit, v.id, i.id)
    assert html_response(conn, 200) =~ "Edit #{i.filename}"
    assert html_response(conn, 200) =~ "Caption"
    refute html_response(conn, 200) =~ "Choose A File to Upload"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: v, image: i} do
    conn = put conn, admin_vendor_image_path(conn, :update, v.id, i.id), image: @valid_attrs
    assert redirected_to(conn) == admin_vendor_image_path(conn, :show, v.id, i.id)

    conn = recycle(conn)
    conn = get conn, admin_vendor_image_path(conn, :show, v.id, i.id)
    assert html_response(conn, 200) =~ @valid_attrs["alt"]

    assert Repo.get_by(@table, %{alt: @valid_attrs["alt"]})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: v, image: i} do
    conn = put conn, admin_vendor_image_path(conn, :update, v.id, i.id), image: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit #{i.filename}"
  end

  test "deletes chosen image and its intersect entity", %{conn: conn, vendor: v, image: i} do
    conn = delete conn, admin_vendor_image_path(conn, :delete, v.id, i.id)
    assert redirected_to(conn) == admin_vendor_image_path(conn, :index, v.id)
    refute Repo.get(@table, i.id)
  end
end
