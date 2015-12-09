defmodule Grid.Admin.VendorController do
  use Grid.Web, :controller
  plug Grid.PageTitle, title: "Vendor"

  require Logger
  alias Grid.Vendor
  alias Grid.Activity
  alias Grid.VendorActivity
  alias Grid.Image

  plug :scrub_params, "vendor" when action in [:create, :update]

  defp all_activities do
    Repo.all(Activity)
  end

  defp load_with_relationships(id) do
    Repo.one!(
      from v in Vendor,
        where: v.id == ^id,
        preload: [:activities, :default_image]
    )
  end

  defp insert_relationships(_, nil), do: :ok #@TODO is it really?
  defp insert_relationships(vendor, activity_ids) do
    # create relationships
    for string_id <- activity_ids, {activity_id, ""} = Integer.parse(string_id) do
      Repo.insert!(%VendorActivity{vendor_id: vendor.id, activity_id: activity_id})
    end
  end


  defp change_image(changeset, image_upload)
  defp change_image(changeset, nil), do: changeset
  defp change_image(changeset, %Plug.Upload{filename: name}) do
      image = %Image{}
        |> Image.changeset(%{filename: name})
        |> Repo.insert!

      Ecto.Changeset.put_change(changeset, :default_image_id, image.id)
  end

  defp upload_image(vendor, image_upload)
  defp upload_image(vendor, nil), do: :ok
  defp upload_image(vendor, %Plug.Upload{}=params) do
    alias Grid.Arc.Image, as: Arc
    spawn fn ->
      image = Repo.get!(Image, vendor.default_image_id)
      Arc.store({params, vendor})
      from(i in Image, where: i.id == ^image.id)
      |> Repo.update_all(set: [
        original: Arc.url({image.filename, vendor}, :original),
        medium: Arc.url({image.filename, vendor}, :medium)
      ])
    end
  end

  defp delete_image_change(%{changes: %{default_image_id: id}}=changeset) do
    Repo.delete!(Image, id)
    Ecto.Changeset.delete_change(changeset, :default_image_id)
  end
  defp delete_image_change(changeset), do: changeset


  def index(conn, _params) do
    vendors = Repo.all(Vendor)
    render(conn, "index.html", vendors: vendors)
  end

  def new(conn, _params) do
    changeset = Vendor.changeset(%Vendor{activities: [], default_image: %Image{}})
    render(conn, "new.html", changeset: changeset, activities: all_activities)
  end

  def create(conn, %{"vendor" => vendor_params}) do
    {:ok, conn} = Repo.transaction fn ->
      image_params = vendor_params["default_image"]
      changeset = Vendor.changeset(%Vendor{}, vendor_params)
      |> change_image(image_params)

      case Repo.insert(changeset) do
        {:ok, vendor} ->
          upload_image(vendor, image_params)
          insert_relationships(vendor, vendor_params["activities"])
          conn
          |> put_flash(:info, "Vendor created successfully.")
          # |> notify_uploading(uploading?)
          |> redirect(to: admin_vendor_path(conn, :index))
        {:error, changeset} ->
          changeset = delete_image_change(changeset)
          render(conn, "new.html", changeset: changeset, activities: all_activities)
      end
    end
    conn
  end

  def show(conn, %{"id" => id}) do
    vendor = load_with_relationships(id)
    render(conn, "show.html", vendor: vendor)
  end

  def edit(conn, %{"id" => id}) do
    vendor = load_with_relationships(id)
    changeset = Vendor.changeset(vendor)
    render(conn, "edit.html", vendor: vendor, changeset: changeset, activities: all_activities)
  end

  def update(conn, %{"id" => id, "vendor" => vendor_params}) do
    vendor = load_with_relationships(id)
    image_params = vendor_params["default_image"]
    changeset = Vendor.changeset(vendor, vendor_params)
    |> change_image(image_params)
    {:ok, conn} = Repo.transaction fn ->
      case Repo.update(changeset) do
        {:ok, vendor} ->
          upload_image(vendor, image_params)
          #clear out old relationships
          Repo.delete_all(from x in VendorActivity, where: x.vendor_id == ^id)
          #and insert the new ones
          insert_relationships(vendor, vendor_params["activities"])
          conn
          |> put_flash(:info, "Vendor updated successfully. If you changed the image, it may still be uploading.")
          |> redirect(to: admin_vendor_path(conn, :show, vendor))
        {:error, changeset} ->
          changeset = delete_image_change(changeset)
          render(conn, "edit.html", vendor: vendor, changeset: changeset, activities: all_activities)
      end
    end
    conn
  end

  def delete(conn, %{"id" => id}) do
    vendor = Repo.get!(Vendor, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(vendor)

    conn
    |> put_flash(:info, "Vendor deleted successfully.")
    |> redirect(to: admin_vendor_path(conn, :index))
  end
end
