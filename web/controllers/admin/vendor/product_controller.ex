defmodule Grid.Admin.Vendor.ProductController do
  use Grid.Web, :controller

  alias Grid.Product

  plug Grid.Plugs.PageTitle, title: "Product"
  plug :scrub_params, "product" when action in [:create, :update]
  plug Grid.Plugs.AssignModel, Product when action in [:edit, :show, :update, :delete]

  def new(conn, _params) do
    render(conn, "new.html",
      changeset: Product.changeset(%Product{}),
      experiences: load_experiences(conn.assigns.vendor)
    )
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(
      %Product{},
      Map.put(product_params, "vendor_id", conn.assigns.vendor.id)
    )

    case Repo.insert(changeset) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product))
      {:error, changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          experiences: load_experiences(conn.assigns.vendor)
        )
    end
  end

  def show(conn, _) do
    product = conn.assigns.product
      |> Repo.preload([:experience, :start_times, :prices])

    render(conn, "show.html",
      product: product,
      page_title: product.name
    )
  end

  def edit(conn, _) do
    product = conn.assigns.product |> Repo.preload(:experience)
    changeset = Product.changeset(product)

    vendor = conn.assigns.vendor |> Repo.preload(:experiences)

    render(conn, "edit.html",
      changeset: changeset,
      experiences: vendor.experiences
    )
  end

  def update(conn, %{"product" => product_params}) do
    product = conn.assigns.product
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor.id, product))
      {:error, changeset} ->
        render(conn, "edit.html",
          changeset: changeset,
          experiences: load_experiences(conn.assigns.vendor)
        )
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: admin_vendor_path(conn, :show, conn.assigns.vendor))
  end


  #############
  ##  Plugs  ##
  #############

  def assign_product(conn, _) do
    vendor = conn.assigns.vendor
    id = conn.params["id"]
    product = Repo.one!(from p in Product,
      where: p.id == ^id and p.vendor_id == ^vendor.id
    )
    assign(conn, :product, product)
  end

  #############
  ## Helpers ##
  #############

  def load_experiences(vendor) do
    vendor = Repo.preload(vendor, :experiences)
    vendor.experiences
  end
end
