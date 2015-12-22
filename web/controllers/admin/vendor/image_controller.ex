defmodule Grid.Admin.Vendor.ImageController do
  use Grid.Web, :controller

  alias Grid.Arc
  alias Grid.Image
  alias Grid.Vendor

  plug :assign_vendor
  plug :assign_image when not action in [:index, :new, :create]

  def index(conn, _) do
    vendor = conn.assigns.vendor |> Repo.preload(:images)
    render(conn, "index.html", vendor: vendor)
  end

  def new(conn, _) do
    vendor = conn.assigns.vendor
    changeset = new_image_changeset(vendor)
    render(conn, "new.html", vendor: vendor, changeset: changeset)
  end

  def create(conn, %{"image" => img_params = %{"file" => file}}) do
    vendor = conn.assigns.vendor
    img_params = Map.put(img_params, "filename", file.filename)

    changeset = new_image_changeset(vendor, img_params)

    case Repo.insert(changeset) do
      {:ok, image} ->
        _async_upload_task = Arc.upload_image(image, file, vendor)

        conn
        |> put_flash(:info, """
        Image successfully added, but if it doesn't appear it may still be uploading.
        """)
        |> redirect(to: admin_vendor_image_path(conn, :index, vendor.id))
      {:error, changeset} ->
        render(conn, "new.html", vendor: vendor, changeset: changeset)
    end
  end

  def create(conn, _invalid_params) do
    vendor = conn.assigns.vendor
    changeset = new_image_changeset(vendor)

    conn
    |> put_flash(:error, "Invalid parameters")
    |> render("new.html", vendor: vendor, changeset: changeset)
  end

  def show(conn, _) do
    render(conn, "show.html",
      image: conn.assigns.image,
      vendor: conn.assigns.vendor
    )
  end

  def edit(conn, _) do
    render(conn, "edit.html",
      vendor: conn.assigns.vendor,
      changeset: conn.assigns.image |> Image.changeset()
    )
  end

  @doc "Only an image's `alt` can be updated by this method"
  def update(conn, %{"image" => %{"alt" => alt}}) do
    vendor = conn.assigns.vendor
    changeset = Image.changeset(conn.assigns.image, %{"alt" => alt})

    case Repo.update(changeset) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image successfully updated.")
        |> redirect(to: admin_vendor_image_path(conn, :show, vendor.id, image.id))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, vendor: vendor)
    end
  end

  def update(conn, _invalid_params) do
    conn
    |> put_flash(:error, "Invalid image parameters.")
    |> render("edit.html",
      vendor: conn.assigns.vendor,
      changeset: conn.assigns.image |> Image.changeset()
    )
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
        |> redirect(to: admin_vendor_image_path(conn, :index, vendor.id))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was a problem setting the default image")
        |> redirect(to: admin_vendor_image_path(conn, :index, vendor.id))
    end
  end

  def delete(conn, _) do
    conn.assigns.image
    |> Repo.delete!

    vendor_id = conn.assigns.vendor.id

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: admin_vendor_image_path(conn, :index, vendor_id))
  end

  ###########
  # Helpers #
  ###########
  defp new_image_changeset(vendor, params \\ :empty) do
    build(vendor, :images) |> Image.changeset(params)
  end
  ###########
  #  Plugs  #
  ###########

  defp assign_vendor(conn, _) do
    vendor = Repo.get!(Vendor, conn.params["vendor_id"])
    assign(conn, :vendor, vendor)
  end

  defp assign_image(conn, _) do
    vendor_id = conn.assigns.vendor.id

    image = from(i in {"vendor_images", Image},
            where: i.assoc_id == ^vendor_id
      )
      |> Repo.get!(conn.params["id"])

    assign(conn, :image, image)
  end
end
