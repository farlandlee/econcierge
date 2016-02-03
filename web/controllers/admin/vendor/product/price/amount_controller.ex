defmodule Grid.Admin.Vendor.Product.Price.AmountController do
  use Grid.Web, :controller

  alias Grid.Amount
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Amount"
  plug :scrub_params, "amount" when action in [:create, :update]
  plug Plugs.Breadcrumb, index: Amount
  plug Plugs.AssignModel, Amount when action in [:show, :edit, :update, :delete]

  defp redirect_to_price_show(conn) do
    redirect(conn, to: admin_vendor_product_price_path(conn,
      :show,
      conn.assigns.vendor,
      conn.assigns.product,
      conn.assigns.price
    ))
  end

  def index(conn, _), do: redirect_to_price_show(conn)
  def show(conn, _),  do: redirect_to_price_show(conn)

  def new(conn, _) do
    changeset = Amount.changeset(%Amount{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"amount" => amount_params}) do
    changeset = Amount.creation_changeset(amount_params, conn.assigns.price.id)

    case Repo.insert(changeset) do
      {:ok, _amount} ->
        conn
        |> put_flash(:info, "Amount created successfully.")
        |> redirect_to_price_show
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _) do
    amount = conn.assigns.amount
    changeset = Amount.changeset(amount)
    render(conn, "edit.html", amount: amount, changeset: changeset)
  end

  def update(conn, %{"amount" => amount_params}) do
    amount = conn.assigns.amount
    changeset = Amount.changeset(amount, amount_params)

    case Repo.update(changeset) do
      {:ok, _amount} ->
        conn
        |> put_flash(:info, "Amount updated successfully.")
        |> redirect_to_price_show
      {:error, changeset} ->
        render(conn, "edit.html", amount: amount, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.amount)

    conn
    |> put_flash(:info, "Amount deleted successfully.")
    |> redirect_to_price_show
  end
end
