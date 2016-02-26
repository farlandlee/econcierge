defmodule Grid.Api.CheckoutController do
  use Grid.Web, :controller

  def checkout(conn, %{"cart" => _bookings, "user" => _user, "stripe_token" => _token}) do
    conn
    |> put_status(201)
    |> json(%{})
  end
end
