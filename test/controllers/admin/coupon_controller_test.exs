defmodule Grid.Admin.CouponControllerTest do
  use Grid.ConnCase

  alias Grid.Coupon
  @valid_attrs %{code: "VALID_CODE_23", disabled: false, expiration_date: "2017-04-17", usage_count: 0, max_usage_count: 42, percent_off: 42}
  @invalid_attrs %{percent_off: -1}

  setup do
    {:ok, coupon: Factory.create(:coupon)}
  end

  test "lists all entries on index", %{conn: conn, coupon: coupon} do
    coupon_with_max = Factory.create(:coupon, max_usage_count: 100, disabled: true)
    conn = get conn, admin_coupon_path(conn, :index)
    response = html_response(conn, 200)
    assert response =~ "Coupon Listing"
    assert response =~ "Code"
    assert response =~ coupon.code
    assert response =~ "Percent off"
    assert response =~ coupon.percent_off |> to_string
    assert response =~ "Usage Count"
    assert response =~ coupon.usage_count |> to_string
    assert response =~ "Expiration date"
    assert response =~ coupon.expiration_date |> to_string
    assert response =~ "Disabled?"
    assert response =~ "glyphicon-unchecked"

    assert response =~ "Code"
    assert response =~ coupon_with_max.code
    assert response =~ "Percent off"
    assert response =~ coupon_with_max.percent_off |> to_string
    assert response =~ "Usage Count"
    assert response =~ "#{coupon_with_max.usage_count} / #{coupon_with_max.max_usage_count}"
    assert response =~ "Expiration date"
    assert response =~ coupon_with_max.expiration_date |> to_string
    assert response =~ "Disabled?"
    assert response =~ "glyphicon-check"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_coupon_path(conn, :new)
    response = html_response(conn, 200)
    assert response =~ "New Coupon"
    assert response =~ "Percent off"
    assert response =~ "Max Usage Count"
    assert response =~ "Expiration date"
    assert response =~ "Disabled?"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_coupon_path(conn, :create), coupon: @valid_attrs
    assert redirected_to(conn) == admin_coupon_path(conn, :index)
    assert Repo.get_by(Coupon, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_coupon_path(conn, :create), coupon: @invalid_attrs
    response = html_response(conn, 200)
    assert response =~ "New Coupon"
  end

  test "shows chosen resource", %{conn: conn, coupon: coupon} do
    conn = get conn, admin_coupon_path(conn, :show, coupon)
    response = html_response(conn, 200)
    assert response =~ "Show Coupon"
    assert response =~ "Code"
    assert response =~ coupon.code
    assert response =~ "Percent off"
    assert response =~ coupon.percent_off |> to_string
    assert response =~ "Usage count"
    assert response =~ coupon.usage_count |> to_string
    assert response =~ "Max usage count"
    assert response =~ coupon.usage_count |> to_string
    assert response =~ "Expiration date"
    assert response =~ coupon.expiration_date |> to_string
    assert response =~ "Disabled?"
    assert response =~ "glyphicon-unchecked"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_coupon_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, coupon: coupon} do
    conn = get conn, admin_coupon_path(conn, :edit, coupon)
    response = html_response(conn, 200)
    assert response =~ "Edit Coupon"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, coupon: coupon} do
    conn = put conn, admin_coupon_path(conn, :update, coupon), coupon: @valid_attrs
    assert redirected_to(conn) == admin_coupon_path(conn, :show, coupon)
    assert Repo.get_by(Coupon, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, coupon: coupon} do
    conn = put conn, admin_coupon_path(conn, :update, coupon), coupon: @invalid_attrs
    response = html_response(conn, 200)
    assert response =~ "Edit Coupon"
  end

  test "deletes chosen resource", %{conn: conn, coupon: coupon} do
    conn = delete conn, admin_coupon_path(conn, :delete, coupon)
    assert redirected_to(conn) == admin_coupon_path(conn, :index)
    refute Repo.get(Coupon, coupon.id)
  end
end
