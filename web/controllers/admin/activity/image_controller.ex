defmodule Grid.Admin.Activity.ImageController do
  use Grid.Web, :controller

  alias Grid.Arc
  alias Grid.Image
  alias Grid.Activity

  plug Grid.Plugs.PageTitle, title: "Activity Image"
  plug Grid.Plugs.AssignModel, {"activity_images", Image} when action in [:show, :edit, :update, :delete, :set_default]

  def new(conn, _) do
    changeset = new_image_changeset(conn.assigns.activity)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"image" => img_params = %{"file" => file}}) do
    activity = conn.assigns.activity
    img_params = Map.put(img_params, "filename", file.filename)

    changeset = new_image_changeset(activity, img_params)

    case Repo.insert(changeset) do
      {:ok, image} ->
        _async_upload_task = Arc.upload_image(image, file, activity)
        redirect(conn, to: admin_activity_path(conn, :show, activity.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, _invalid_params) do
    changeset = new_image_changeset(conn.assigns.activity)

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
      |> Activity.changeset(%{})
      |> Ecto.Changeset.put_change(:default_image_id, image.id)

    case Repo.update(activity_changeset) do
      {:ok, activity} ->
        conn
        |> redirect(to: admin_activity_path(conn, :show, activity))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was a problem setting the default image")
        |> redirect(to: admin_activity_path(conn, :show, activity))
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: admin_activity_path(conn, :show, conn.assigns.activity))
  end

  ###########
  # Helpers #
  ###########

  defp new_image_changeset(activity, params \\ :empty) do
    build_assoc(activity, :images) |> Image.changeset(params)
  end
end
