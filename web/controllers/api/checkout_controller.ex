defmodule Grid.Api.CheckoutController do
  use Grid.Web, :controller

  def checkout(conn, %{"cart" => _bookings, "user" => _user}) do
    conn
    |> put_status(201)
    |> json(%{})
  end
end
