defmodule Grid.Api.SharedCartControllerTest do
  use Grid.ConnCase

  alias Grid.SharedCart

  @valid_attrs %{"bookings" => [%{
        "activity" => "1",
        "category" => "2",
        "date" => "2016-04-25",
        "experience" => "2",
        "product" => "7",
        "quantities" => [%{"cost" => 100, "id" => 13, "quantity" => 1}],
        "startTime" => %{"id" => 7, "time" => "00:00:00"}
      }]}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creating a cart", %{conn: conn} do
    conn = post conn, api_shared_cart_path(conn, :create), @valid_attrs
    response = json_response(conn, 201)
    [shared_cart] = Repo.all(SharedCart)
    assert response["url"] == explore_url(Grid.Endpoint, :shared_cart, shared_cart.uuid)
  end

  test "show a cart", %{conn: conn} do
    cart = SharedCart.creation_changeset(@valid_attrs) |> Repo.insert!
    conn = get conn, api_shared_cart_path(conn, :show, cart.uuid)
    response = json_response(conn, 200)
    shared_cart = response["shared_cart"]
    assert shared_cart["uuid"] == cart.uuid
    assert is_list(shared_cart["bookings"])
  end
end
