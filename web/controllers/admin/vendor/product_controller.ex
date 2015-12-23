defmodule Grid.Admin.Vendor.ProductController do
  use Grid.Web, :controller

  alias Grid.ActivityCategory
  alias Grid.Product
  alias Grid.ProductActivityCategory

  plug Grid.Plugs.PageTitle, title: "Product"
  plug :scrub_params, "product" when action in [:create, :update]
  plug :validate_activity_categories when action in [:create, :update]

  def index(conn, _params) do
    products = Repo.all(from p in Product, preload: :activity)
    render(conn, "index.html",
      products: products,
      page_title: "#{conn.assigns.vendor.name} Products"
    )
  end

  def new(conn, _params) do
    changeset = Product.changeset(%Product{})

    render(conn, "new.html",
      changeset: changeset,
      activity_categories: load_activity_categories
    )
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(%Product{}, product_params)
      |> Ecto.Changeset.put_change(:vendor_id, conn.assigns.vendor.id)
      |> Ecto.Changeset.put_change(:activity_id, conn.assigns.param_activity.id)

    Repo.transaction(fn ->
      case Repo.insert(changeset) do
        {:ok, product} ->
          conn.assigns.param_activity_categories
          |> add_product_activity_categories(product.id)
        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
    |> render_create(conn)
  end

  defp render_create({:ok, _product}, conn) do
    conn
    |> put_flash(:info, "Product created successfully.")
    |> redirect(to: admin_vendor_product_path(conn, :index, conn.assigns.vendor.id))
  end

  defp render_create({:error, changeset}, conn) do
    render(conn, "new.html",
      changeset: changeset,
      activity_categories: load_activity_categories
    )
  end

  def show(conn, %{"id" => id}) do
    product = get_with_assocs(id)
    render(conn, "show.html",
      product: product,
      page_tite: product.name
    )
  end

  def edit(conn, %{"id" => id}) do
    product = get_with_assocs(id)
    changeset = Product.changeset(product)

    render(conn, "edit.html",
      vendor: conn.assigns.vendor,
      changeset: changeset,
      activity_categories: load_activity_categories
    )
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)
      |> Ecto.Changeset.put_change(:activity_id, conn.assigns.param_activity.id)

    Repo.transaction(fn ->
      case Repo.update(changeset) do
        {:ok, product} ->
          Repo.delete_all(from pac in ProductActivityCategory,
            where: pac.product_id == ^product.id)

          conn.assigns.param_activity_categories
          |> add_product_activity_categories(product.id)

          product
        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
    |> render_update(conn)
  end

  defp render_update({:ok, product}, conn) do
    conn
    |> put_flash(:info, "Product updated successfully.")
    |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor.id, product))
  end

  defp render_update({:error, changeset}, conn) do
    render(conn, "edit.html",
      vendor: conn.assigns.vendor,
      changeset: changeset,
      activity_categories: load_activity_categories
    )
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Product, id)
    |> Repo.delete!

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: admin_vendor_product_path(conn, :index, conn.assigns.vendor.id))
  end


  #############
  ##  Plugs  ##
  #############

  def validate_activity_categories(conn, _) do
    ac_ids = conn.params["product"]["activity_categories"] || []
    activity_categories = Repo.all(from ac in ActivityCategory,
      where: ac.id in ^ac_ids,
      preload: [:activity, :category]
    )

    activities_count = activity_categories
      |> Enum.map(&(&1.activity_id))
      |> Enum.into(HashSet.new)
      |> HashSet.size

    if activities_count != 1 do
      error_message = case activities_count do
        0 -> "Product must have at least one Activity Category"
        _ -> "All selected Activity Categories must be from the same activity."
      end

      redirection = case action_name(conn) do
        :create -> admin_vendor_product_path(conn, :new, conn.assigns.vendor)
        :update -> admin_vendor_product_path(conn, :edit, conn.assigns.vendor, conn.params["id"])
      end

      conn
      |> put_flash(:error, error_message)
      |> redirect(to: redirection)
      |> halt
    else
      conn
      |> assign(:param_activity_categories, activity_categories)
      |> assign(:param_activity, hd(activity_categories).activity)
    end
  end

  #############
  ## Helpers ##
  #############

  defp get_with_assocs(id) do
    Repo.one!(from p in Product,
      where: p.id == ^id,
      preload: [:activity, activity_categories: :category]
    )
  end

  def add_product_activity_categories(activity_categories, product_id) do
    for ac <- activity_categories do
      Repo.insert!(%ProductActivityCategory{
        activity_category_id: ac.id,
        product_id: product_id
      })
    end
  end

  def load_activity_categories do
    Repo.all(from ac in ActivityCategory,
      join: a in assoc(ac, :activity),
      join: c in assoc(ac, :category),
      order_by: [asc: a.name, asc: c.name],
      preload: [activity: a, category: c]
    )
  end
end
