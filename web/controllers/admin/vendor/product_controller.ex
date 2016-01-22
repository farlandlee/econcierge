defmodule Grid.Admin.Vendor.ProductController do
  use Grid.Web, :controller

  alias Grid.Product
  alias Grid.Price
  alias Grid.StartTime

  plug Grid.Plugs.PageTitle, title: "Product"
  plug :scrub_params, "product" when action in [:create, :update]
  plug Grid.Plugs.AssignModel, Product when action in [:clone, :edit, :show, :update, :delete]

  def index(conn, _) do
    redirect(conn, to: admin_vendor_path(conn, :show, conn.assigns.vendor))
  end

  def new(conn, _params) do
    render(conn, "new.html",
      changeset: Product.changeset(%Product{}),
      experiences: load_experiences(conn.assigns.vendor)
    )
  end

  def create(conn, %{"product" => params}) do
    params = params |> Map.put("vendor_id", conn.assigns.vendor.id)
    changeset = Product.changeset(%Product{}, params)

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

  def clone(conn, _) do
    product = conn.assigns.product |> Repo.preload([
      :prices, :start_times
      ])
    clone = Product.clone(product)

    {:ok, conn} = Repo.transaction fn ->
      case Repo.insert(clone) do
        {:ok, clone} ->
          # clone start times
          for start_time <- product.start_times do
            start_time
            |> StartTime.clone(product_id: clone.id)
            |> Repo.insert!
          end
          # clone prices, set default_price once it's been cloned
          for price <- product.prices do
            price_clone = price
              |> Price.clone(product_id: clone.id)
              |> Repo.insert!
            # Set the default price of the clone to the cloned default price
            if price.id == product.default_price_id do
              clone
              |> Ecto.Changeset.change(default_price_id: price_clone.id)
              |> Repo.update!
            end
          end

          conn
          |> put_flash(:info, "Product successfully cloned.")
          |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, clone))
        {:error, changeset} ->
          conn
          |> put_flash(:error, "Error cloning product.")
          |> redirect(to: admin_vendor_path(conn, :show, conn.assigns.vendor))
      end
    end
    conn
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
  ## Helpers ##
  #############

  def load_experiences(vendor) do
    vendor = Repo.preload(vendor, :experiences)
    vendor.experiences
  end
end
