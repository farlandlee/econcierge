defmodule Grid.Api.CouponView do
  use Grid.Web, :view

  def render("show.json", %{coupon: coupon}) do
    %{coupon: render_one(coupon, Grid.Api.CouponView, "coupon.json")}
  end

  def render("coupon.json", %{coupon: coupon}) do
    %{
      id: coupon.id,
      code: coupon.code,
      percent_off: coupon.percent_off
    }
  end
end
