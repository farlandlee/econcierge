defmodule Grid.Api.OrderController do
  use Grid.Web, :controller

  alias Grid.{
    Order,
    User
  }

  plug :load_customer when action in [:process_cart]
  plug :load_cart when action in [:process_cart]
  plug :prepare_order_params when action in [:process_cart]

  def process_cart(conn, _) do
    changeset = Order.creation_changeset(conn.assigns.order_params, conn.assigns.customer.id)

    case Repo.insert(changeset) do
      {:ok, order} ->
        conn
        |> put_status(:created)
        |> render("show.json", order: order)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Grid.ErrorView, "422.json", changeset: changeset)
    end
  end

  ###########
  ## Plugs ##
  ###########

  def load_customer(conn, _) do
    user_params = conn.params["user"]
    do_load_customer(conn, user_params)
  end

  def load_cart(conn, _) do
    case conn.params["cart"] do
      cart = [_|_] -> assign(conn, :cart, cart)
      _ -> halt_422(conn, ["No items in cart"])
        |> halt
    end
  end

  def prepare_order_params(conn, _) do
    case Grid.Cart.to_order_params(conn.assigns.cart) do
      {:ok, params} -> assign(conn, :order_params, params)
      {:error, error} ->
        halt_422(conn, [error])
    end
  end

  defp do_load_customer(conn, %{"email" => email} = user_params) do
    changeset = case Repo.get_by(User, email: email) do
      nil  -> User.changeset(%User{}, user_params)
      user -> User.changeset(user, user_params)
    end

    case Repo.insert_or_update(changeset) do
      {:ok, user} -> assign(conn, :customer, user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Grid.ErrorView, "422.json", changeset: changeset)
        |> halt
    end
  end
  defp do_load_customer(conn, %{}) do
    halt_422(conn, ["No user in payload"])
  end
  defp do_load_customer(conn, nil), do: do_load_customer(conn, %{})

  def halt_422(conn, errors) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: errors})
    |> halt
  end
end
