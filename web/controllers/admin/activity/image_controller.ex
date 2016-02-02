defmodule Grid.Admin.Activity.ImageController do
  use Grid.Web, :controller

  alias Grid.Activity
  alias Grid.Arc
  alias Grid.Image
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Activity Image"
  plug Plugs.Breadcrumb, index: Image

  @assign_model_actions [:show, :edit, :update, :delete, :set_default]
  plug Plugs.AssignModel, {"activity_images", Image} when action in @assign_model_actions
  plug Plugs.Breadcrumb, [show: Image] when action in [:show, :edit]

  def index(conn, _) do
    redirect(conn, to: admin_activity_path(conn, :show, conn.assigns.activity))
  end

  def new(conn, _) do
    changeset = Image.changeset(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"image" => img_params = %{"file" => file}}) do
    activity = conn.assigns.activity
    changeset = Image.creation_changeset(activity, img_params)

    case Repo.insert(changeset) do
      {:ok, image} ->
        _async_upload_task = Arc.upload_image(image, file, activity)
        redirect(conn, to: admin_activity_path(conn, :show, activity, tab: "images"))
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
        |> redirect(to: admin_activity_image_path(conn, :show, conn.assigns.activity, image))
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
    activity = conn.assigns.activity
    image = conn.assigns.image

    activity_changeset = activity
      |> Activity.changeset(%{default_image_id: image.id})

    case Repo.update(activity_changeset) do
      {:ok, activity} ->
        conn
        |> redirect(to: admin_activity_path(conn, :show, activity, tab: "images"))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was a problem setting the default image")
        |> redirect(to: admin_activity_path(conn, :show, activity, tab: "images"))
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: admin_activity_path(conn, :show, conn.assigns.activity))
  end
end
