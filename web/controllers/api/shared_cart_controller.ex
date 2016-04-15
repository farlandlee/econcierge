defmodule Grid.Api.SharedCartController do
  use Grid.Web, :controller

  alias Grid.{
    SharedCart,
    Repo
  }

  def create(conn, params) do
    shared_cart = params
      |> SharedCart.creation_changeset
      |> Repo.insert!
      
    conn
    |> put_status(:created)
    |> render("share.json", shared_cart: shared_cart)
  end

  def show(conn, %{"uuid" => uuid}) do
    shared_cart = Repo.get_by!(SharedCart, uuid: uuid)
    render(conn, "show.json", shared_cart: shared_cart)
  end
end
