defmodule Grid.StripeTest do
  use ExUnit.Case, async: true

  alias Grid.{
    Factory,
    Repo,
    User,
    OrderItem
  }

  # Functions we're testing
  import Grid.Stripe, only: [
    link_customer: 2,
    charge_customer: 1
  ]

  setup do
    user = Factory.create(:user)
    product = Factory.create(:product)
    order = Factory.create_user_order_for_product(user, product)
    item = order.order_items |> hd

    {:ok, order: order, order_item: item}
  end

  test "link new customer sets stripe_id" do
    user = Factory.create(:user)
    stripe_token = :random.uniform() |> to_string

    link_customer(user, stripe_token)
    # Curse you GenServer.cast!
    :timer.sleep(100)

    user = Repo.get(User, user.id)
    assert user
    assert user.stripe_id
  end

  test "link existing customer doesn't change stripe_id" do
    user = Factory.create(:user, stripe_id: "foo")
    stripe_token = :random.uniform() |> to_string

    link_customer(user, stripe_token)
    # Curse you GenServer.cast!
    :timer.sleep(100)

    user = Repo.get(User, user.id)
    assert user
    assert user.stripe_id == "foo"
  end

  test "charge customer updates order item with charge data", %{order_item: item} do
    charge_customer(item)
    :timer.sleep(100)

    item = Repo.get(OrderItem, item.id)
    assert item
    assert item.stripe_charge_id
    assert item.charged_at
  end

  test "charge customer with error", %{order_item: item} do
    # This amount is hardcoded to error in lib/stripe.ex
    item = item
      |> OrderItem.changeset(%{amount: 312120.12})
      |> Repo.update!

    charge_customer(item)
    :timer.sleep(100)

    item = Repo.get(OrderItem, item.id)
    assert item
    assert item.status == "errored"
    assert item.status_info
    assert is_map(item.status_info)
  end
end
