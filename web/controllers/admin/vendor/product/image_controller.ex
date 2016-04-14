defmodule Grid.Admin.Vendor.Product.ImageController do
  use Grid.Web, :controller

  alias Grid.Arc
  alias Grid.Image
  alias Grid.Plugs
  alias Grid.Product

  plug Plugs.PageTitle, title: "Product Image"
  plug Plugs.Breadcrumb, index: Image

  @assign_model_actions [:show, :edit, :update, :delete, :set_default]
  plug Plugs.AssignModel, {"product_images", Image} when action in @assign_model_actions
  plug Plugs.Breadcrumb, [show: Image] when action in [:show, :edit]

  def index(conn, _) do
    redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product, tab: "images"))
  end

  def new(conn, _) do
    product = conn.assigns.product
    changeset = Image.changeset(%Image{})
    render(conn, "new.html", changeset: changeset, page_title: "Add Image for #{product.name}")
  end

  def create(conn, %{"image" => img_params = %{"file" => file}}) do
    product = conn.assigns.product
    changeset = Image.creation_changeset(product, img_params)

    case Repo.insert(changeset) do
      {:ok, image} ->
        _async_upload_task = Arc.upload_image(image, file, product)
        redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product, tab: "images"))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, _invalid_params) do
    changeset = Image.changeset(%Image{})

    conn
    |> put_flash(:error, "Invalid parameters")
    |> render("new.html", changeset: changeset)
  end

  def show(conn, _) do
    render(conn, "show.html", page_title: conn.assigns.image.filename)
  end

  def edit(conn, _) do
    render(conn, "edit.html", changeset: Image.changeset(conn.assigns.image))
  end

  def update(conn, %{"image" => params}) do
    conn.assigns.image
    |> Image.changeset(params)
    |> Repo.update
    |> case do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image successfully updated.")
        |> redirect(to: admin_vendor_product_image_path(conn, :show, conn.assigns.vendor, conn.assigns.product, image))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def update(conn, _invalid_params) do
    conn
    |> put_flash(:error, "Invalid image parameters.")
    |> render("edit.html", changeset: Image.changeset(conn.assigns.image))
  end

  def set_default(conn, _) do
    product = conn.assigns.product
    image = conn.assigns.image

    product_changeset = product
      |> Product.changeset(%{default_image_id: image.id})

    case Repo.update(product_changeset) do
      {:ok, product} ->
        conn
        |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product, tab: "images"))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was a problem setting the default image")
        |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product, tab: "images"))
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product, tab: "images"))
  end
end
