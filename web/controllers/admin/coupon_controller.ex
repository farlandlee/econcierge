defmodule Grid.Admin.CouponController do
  use Grid.Web, :controller

  alias Grid.Coupon
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Coupon"
  plug :scrub_params, "coupon" when action in [:create, :update]

  @assign_model_actions [:show, :edit, :update, :delete]
  plug Plugs.AssignModel, Coupon when action in @assign_model_actions
  plug Plugs.Breadcrumb, index: Coupon
  plug Plugs.Breadcrumb, [show: Coupon] when action in [:show, :edit]

  def index(conn, _) do
    coupons = Repo.all(Coupon)
    render(conn, "index.html", coupons: coupons)
  end

  def new(conn, _) do
    changeset = Coupon.changeset(%Coupon{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"coupon" => coupon_params}) do
    changeset = Coupon.changeset(%Coupon{}, coupon_params)

    case Repo.insert(changeset) do
      {:ok, _coupon} ->
        conn
        |> put_flash(:info, "Coupon created successfully.")
        |> redirect(to: admin_coupon_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    coupon = conn.assigns.coupon
    render(conn, "show.html", coupon: coupon)
  end

  def edit(conn, _) do
    coupon = conn.assigns.coupon
    changeset = Coupon.changeset(coupon)
    render(conn, "edit.html", coupon: coupon, changeset: changeset)
  end

  def update(conn, %{"coupon" => coupon_params}) do
    coupon = conn.assigns.coupon
    changeset = Coupon.changeset(coupon, coupon_params)

    case Repo.update(changeset) do
      {:ok, coupon} ->
        conn
        |> put_flash(:info, "Coupon updated successfully.")
        |> redirect(to: admin_coupon_path(conn, :show, coupon))
      {:error, changeset} ->
        render(conn, "edit.html", coupon: coupon, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.coupon)

    conn
    |> put_flash(:info, "Coupon deleted successfully.")
    |> redirect(to: admin_coupon_path(conn, :index))
  end
end
