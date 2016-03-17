defmodule Grid.Api.CouponControllerTest do
  use Grid.ConnCase

  # alias Grid.Coupon
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp get_by_code(conn, code) do
    put conn, api_coupon_path(conn, :get_by_code, %{code: code})
  end

  test "gets coupon by code", %{conn: conn} do
    coupon = Factory.create(:coupon)
    conn = get_by_code(conn, coupon.code)
    response = json_response(conn, 200)
    assert response["coupon"]["code"] == coupon.code
  end

  test "404s expired codes", %{conn: conn} do
    coupon = Factory.create(:coupon, expiration_date: %Ecto.Date{year: 2015, month: 1, day: 1})
    assert_raise Grid.NotFoundError, "Invalid code", fn ->
      get_by_code(conn, coupon.code)
    end
  end

  test "404s depleted codes", %{conn: conn} do
    coupon = Factory.create(:coupon, max_usage_count: 1, usage_count: 1)
    assert_raise Grid.NotFoundError, "Invalid code", fn ->
      get_by_code(conn, coupon.code)
    end
  end

  test "404s unknown codes", %{conn: conn} do
    assert_raise Grid.NotFoundError, "Invalid code", fn ->
      get_by_code(conn, "INVALID_CODE")
    end
  end

end
