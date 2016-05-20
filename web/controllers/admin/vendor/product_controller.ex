defmodule Grid.Admin.Vendor.ProductController do
  use Grid.Web, :controller

  import Grid.Models.ManyToMany

  alias Grid.Plugs

  alias Grid.Activity
  alias Grid.Amount
  alias Grid.Product
  alias Grid.Price
  alias Grid.StartTime

  plug Plugs.PageTitle, title: "Product"

  plug :scrub_params, "product" when action in [:create, :update]
  plug :scrub_duration_time     when action in [:create, :update]

  @assign_model_actions [:clone, :edit, :show, :update, :delete]
  plug Plugs.AssignModel, Product when action in @assign_model_actions
  plug :assign_form_data when action in [:new, :create, :edit, :update]
  plug :set_duration_time when action in @assign_model_actions

  plug Plugs.Breadcrumb, index: Product
  plug Plugs.Breadcrumb, [show: Product] when action in [:edit, :show]

  def index(conn, _), do:
    redirect(conn, to: admin_vendor_path(conn, :show, conn.assigns.vendor, tab: "products"))

  def new(conn, %{"activity_id" => _activity_id}) do
    changeset = Product.changeset(%Product{})
    render(conn, "new.html", changeset: changeset, )
  end

  def new(conn, _) do
    conn
    |> put_flash(:error, "Must select activity before clicking Add Product")
    |> redirect(to: admin_vendor_path(conn, :show, conn.assigns.vendor))
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.creation_changeset(product_params, conn.assigns.vendor.id)

    {:ok, conn} = Repo.transaction(fn ->
      case Repo.insert(changeset) do
        {:ok, product} ->
          manage_associated(product, :product_amenity_options, :amenity_option_id, product_params["amenity_option_id"])

          conn
          |> put_flash(:info, "Product created successfully.")
          |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end)

    conn
  end

  def show(conn, _) do
    product = conn.assigns.product
      |> Repo.preload([
        :activity,
        :experience,
        :images,
        :meeting_location,
        start_times: :season,
        prices: :amounts,
        default_price: :amounts,
        amenity_options: :amenity
      ])

    render(conn, "show.html",
      product: product,
      page_title: product.name
    )
  end

  def edit(conn, _) do
    changeset = Product.changeset(conn.assigns.product)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"product" => product_params}) do
    changeset = Product.changeset(conn.assigns.product, product_params)

    {:ok, conn} = Repo.transaction(fn ->
      case Repo.update(changeset) do
        {:ok, product} ->
          manage_associated(product, :product_amenity_options, :amenity_option_id, product_params["amenity_option_id"])

          conn
          |> put_flash(:info, "Product updated successfully.")
          |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product))
        {:error, changeset} ->
          render(conn, "edit.html", changeset: changeset)
      end
    end)

    conn
  end

  def delete(conn, _) do
    product = conn.assigns.product

    conn = case assoc(product, :order_items) |> Repo.all |> Enum.count do
      0 ->
        Repo.delete!(product)
        conn |> put_flash(:info, "Product deleted successfully.")
      _ ->
        conn |> put_flash(:error, "Cannot delete product because it has received orders.")
    end

    redirect(conn, to: admin_vendor_path(conn, :show, conn.assigns.vendor, tab: "products"))
  end

  def clone(conn, _) do
    product = conn.assigns.product |> Repo.preload([
      :start_times,
      prices: :amounts
      ])
    product_clone = Product.clone(product)
    {:ok, conn} = Repo.transaction fn ->
      case Repo.insert(product_clone) do
        {:ok, product_clone} ->
          # clone start times
          for start_time <- product.start_times do
            start_time
            |> StartTime.clone(product_id: product_clone.id)
            |> Repo.insert!
          end
          # clone prices, set default_price once it's been cloned
          for price <- product.prices do
            price_clone = price
              |> Price.clone(product_id: product_clone.id)
              |> Repo.insert!

            for amount <- price.amounts do
              amount
              |> Amount.clone(price_id: price_clone.id)
              |> Repo.insert!
            end
            # Set the default price of the clone to the cloned default price
            if price.id == product.default_price_id do
              product_clone
              |> Product.default_price_changeset(price_clone.id)
              |> Repo.update!
            end
          end

          conn
          |> put_flash(:info, "Product successfully cloned.")
          |> redirect(to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product_clone))
        {:error, _changeset} ->
          conn
          |> put_flash(:error, "Error cloning product.")
          |> redirect(to: admin_vendor_path(conn, :show, conn.assigns.vendor))
      end
    end
    conn
  end

  #############
  ##  Plugs  ##
  #############

  defp try_parse_as_int(nil), do: nil

  defp try_parse_as_int(int) when is_integer(int), do: int

  defp try_parse_as_int(number) do
    case Integer.parse(number) do
      {int, ""} -> int
      _ -> nil
    end
  end

  @doc """
  Gets the "duration_time_hours" and "duration_time_minutes" fields
  from a form submission and combines them to set the "duration" field.
  """
  def scrub_duration_time(conn, _) do
    product_params = conn.params["product"]

    hours_param = product_params["duration_hours"]
      |> try_parse_as_int
    minutes_param = product_params["duration_minutes"]
      |> try_parse_as_int

    duration = cond do
      minutes_param && hours_param -> hours_param * 60 + minutes_param
      hours_param -> hours_param * 60
      minutes_param -> minutes_param
      :no_duration -> product_params["duration"]
    end

    if duration do
      product_params = Map.put(product_params, "duration", duration)
      params = Map.put(conn.params, "product", product_params)
      %{conn | params: params}
    else
      conn
    end
  end

  def set_duration_time(conn, _) do
    product = conn.assigns.product |> Product.set_duration_time
    assign(conn, :product, product)
  end

  def assign_form_data(conn, _) do
    vendor = conn.assigns.vendor
      |> Repo.preload(:locations)

    add_location = admin_vendor_location_path(conn, :new, vendor)
    activity = load_activity(conn) |> Repo.preload([
      :experiences,
      amenities: [amenity_options: :product_amenity_options]
    ])

    conn
    |> assign(:add_location, add_location)
    |> assign(:locations, vendor.locations)
    |> assign(:activity, activity)
  end

  defp load_activity(%Plug.Conn{params: %{"activity_id" => activity_id}}),
    do: Repo.get(Activity, activity_id)
  defp load_activity(%Plug.Conn{assigns: %{product: p}}),
    do: assoc(p, :activity) |> Repo.one

end
