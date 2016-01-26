defmodule Grid.Admin.Vendor.Product.PriceController do
  use Grid.Web, :controller

  alias Grid.Plugs
  alias Grid.Price
  alias Grid.Product

  plug Plugs.PageTitle, title: "Price"
  plug :scrub_params, "price" when action in [:create, :update]
  plug Plugs.Breadcrumb, index: Price
  plug Plugs.AssignModel, Price when action in [:edit, :update, :delete, :set_default]
  plug Plugs.Breadcrumb, [show: Price] when action in [:edit]

  def index(conn, _) do
    redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product))
  end

  def show(conn, _) do
    redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product))
  end

  def new(conn, _params) do
    changeset = Price.changeset(%Price{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"price" => price_params}) do
    product = conn.assigns.product
    changeset = Price.changeset(%Price{}, price_params)
      |> Ecto.Changeset.put_change(:product_id, product.id)

    case Repo.insert(changeset) do
      {:ok, _price} ->
        conn
        |> put_flash(:info, "Price created successfully.")
        |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _) do
    price = conn.assigns.price
    changeset = Price.changeset(price)
    render(conn, "edit.html", price: price, changeset: changeset)
  end

  def update(conn, %{"price" => price_params}) do
    price = conn.assigns.price
    changeset = Price.changeset(price, price_params)

    case Repo.update(changeset) do
      {:ok, _price} ->
        conn
        |> put_flash(:info, "Price updated successfully.")
        |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product))
      {:error, changeset} ->
        render(conn, "edit.html", price: price, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.price)

    conn
    |> put_flash(:info, "Price deleted successfully.")
    |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product))
  end

  def set_default(conn, _) do
    product = conn.assigns.product
    product_changeset = Product.changeset(product, %{})
      |> Ecto.Changeset.put_change(:default_price_id, conn.assigns.price.id)

    case Repo.update(product_changeset) do
      {:ok, product} ->
        conn
        |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was a problem changing the default price")
        |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product))
    end
  end
end
