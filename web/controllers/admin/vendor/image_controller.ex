defmodule Grid.Admin.Vendor.ImageController do
  use Grid.Web, :controller

  alias Grid.Arc
  alias Grid.Image
  alias Grid.Plugs
  alias Grid.Vendor

  plug Plugs.PageTitle, title: "Vendor Image"
  plug Plugs.Breadcrumb, index: Image

  @assign_model_actions [:show, :edit, :update, :delete, :set_default]
  plug Plugs.AssignModel, {"vendor_images", Image} when action in @assign_model_actions
  plug Plugs.Breadcrumb, [show: Image] when action in [:show, :edit]

  def index(conn, _) do
    redirect(conn, to: admin_vendor_path(conn, :show, conn.assigns.vendor))
  end

  def new(conn, _) do
    vendor = conn.assigns.vendor
    changeset = new_image_changeset(vendor)
    render(conn, "new.html", changeset: changeset, page_title: "Add Image for #{vendor.name}")
  end

  def create(conn, %{"image" => img_params = %{"file" => file}}) do
    vendor = conn.assigns.vendor
    img_params = Map.put(img_params, "filename", file.filename)

    changeset = new_image_changeset(vendor, img_params)

    case Repo.insert(changeset) do
      {:ok, image} ->
        _async_upload_task = Arc.upload_image(image, file, vendor)
        redirect(conn, to: admin_vendor_path(conn, :show, vendor.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, _invalid_params) do
    changeset = new_image_changeset(conn.assigns.vendor)

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

  @doc "Only an image's `alt` can be updated by this method"
  def update(conn, %{"image" => %{"alt" => alt}}) do
    conn.assigns.image
    |> Image.changeset(%{"alt" => alt})
    |> Repo.update
    |> case do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image successfully updated.")
        |> redirect(to: admin_vendor_image_path(conn, :show, conn.assigns.vendor, image))
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
    vendor = conn.assigns.vendor
    image = conn.assigns.image

    vendor_changeset = vendor
      |> Vendor.changeset(%{})
      |> Ecto.Changeset.put_change(:default_image_id, image.id)

    case Repo.update(vendor_changeset) do
      {:ok, vendor} ->
        conn
        |> redirect(to: admin_vendor_path(conn, :show, vendor))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was a problem setting the default image")
        |> redirect(to: admin_vendor_path(conn, :show, vendor))
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: admin_vendor_path(conn, :show, conn.assigns.vendor))
  end

  ###########
  # Helpers #
  ###########

  defp new_image_changeset(vendor, params \\ :empty) do
    build_assoc(vendor, :images) |> Image.changeset(params)
  end
end
