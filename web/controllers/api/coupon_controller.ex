defmodule Grid.Api.CouponController do
  use Grid.Web, :controller

  alias Grid.Coupon

  plug :scrub_params, "code" when action in [:get_by_code]

  def get_by_code(conn, %{"code" => code}) do
    coupon = coupon_for_code!(code)
    render(conn, "show.json", coupon: coupon)
  end

  ##############
  ## Helpers  ##
  ##############

  defp coupon_for_code(nil) do
    nil
  end

  defp coupon_for_code(code) do
    code = Coupon.normalize_code(code)
    coupon = Repo.get_by(Coupon, code: code)
    if coupon && Coupon.valid?(coupon) do
      coupon
    end
  end

  defp coupon_for_code!(code) do
    case coupon_for_code(code) do
      nil -> raise Grid.NotFoundError, message: "Invalid code"
      coupon -> coupon
    end
  end
end
