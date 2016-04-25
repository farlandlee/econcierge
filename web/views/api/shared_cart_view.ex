defmodule Grid.Api.SharedCartView do
  use Grid.Web, :view

  alias Grid.Endpoint

  def render("share.json", %{shared_cart: %{uuid: uuid}}) do
    %{
      url: explore_url(Endpoint, :shared_cart, uuid),
      uuid: uuid
    }
  end

  def render("show.json", %{shared_cart: shared_cart}) do
    %{shared_cart: render_one(shared_cart, __MODULE__, "shared_cart.json")}
  end

  def render("shared_cart.json", %{shared_cart: shared_cart}) do
    %{
      bookings: shared_cart.bookings["bookings"],
      uuid: shared_cart.uuid
    }
  end
end
