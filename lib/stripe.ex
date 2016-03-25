defmodule Grid.Stripe do
  use GenServer

  alias Grid.{
    Repo,
    OrderItem
  }

  #########
  ## API ##
  #########

  def link_customer(customer, stripe_token) do
    GenServer.cast(__MODULE__, {:link_customer, customer, stripe_token})
  end

  def charge_customer(order_item = %OrderItem{}) do
    GenServer.cast(__MODULE__, {:charge_customer, order_item})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  #########################
  ## GenServer Callbacks ##
  #########################

  def init([]) do
    {:ok, %{}}
  end

  @doc """
  Will create a new customer in stripe and link that customer to our local user.
  If the user has aleady been linked, then we update the stripe credit card
  "source".
  """
  def handle_cast({:link_customer, %{stripe_id: id}, stripe_token}, state)
  when not is_nil(id) do
    {:ok, _} = stripe_update_customer(id, [source: stripe_token])

    {:noreply, state}
  end

  def handle_cast({:link_customer, customer, stripe_token}, state) do
    {:ok, %{id: id}} = stripe_create_customer([
      email: customer.email,
      description: customer.name,
      source: stripe_token
    ])

    customer
    |> Grid.User.changeset(%{stripe_id: id})
    |> Repo.update!

    {:noreply, state}
  end

  @doc """
  Charge customer for the order item amount.
  """
  def handle_cast({:charge_customer, order_item}, state) do
    order_item
      = %{order: %{user: user}, product: product}
      = Grid.Repo.preload(order_item, [order: :user, product: :vendor])

    params = [
      customer: user.stripe_id,
      description: String.replace("#{product.name} - #{product.vendor.name}", "&", "%26")
    ]

    percent_off = order_item.order.coupon["percent_off"] || 0

    cost = order_item.amount * (1 - percent_off / 100)

    cost_in_cents = round(cost * 100)

    case stripe_create_charge(cost_in_cents, params) do
      {:ok, %{id: id}} ->
        order_item
        |> OrderItem.charge_changeset(id, cost)
        |> Repo.update!
      {:error, %{"error" => error}} ->
        handle_error(order_item, error)
    end

    {:noreply, state}
  end

  defp handle_error(order_item, error) do
    to = "book@outpostjh.com"
    subject = "Order Processing Error (Order ##{order_item.order_id})"
    body = """
    There was an error charging order item ##{order_item.id}
    for order ##{order_item.order_id}.

    Details follow:

    #{Poison.encode! error, pretty: true}
    """
    tag = "Payment Error"

    Postmark.email to, body, subject, tag

    order_item
    |> OrderItem.error_changeset(error)
    |> Repo.update!
  end

  #####################
  ##     Stripe      ##
  #####################
  if Mix.env == :test do

    defp mocked_stripe_resp do
      {:ok, %{id: :random.uniform() |> to_string}}
    end

    defp stripe_create_customer(_params) do
      mocked_stripe_resp()
    end

    defp stripe_update_customer(_id, _params) do
      mocked_stripe_resp()
    end

    # 31212012 is 1337 for "ERROR"!
    # I'm so clever.
    # Set an order_items amountto 312120.12 to trigger this
    defp stripe_create_charge(31212012, _) do
      {:error,
        %{
          "error" => %{
            "charge" => "ch_17mT7vKHfbG43EWZeHMIo3sI",
            "code" => "card_declined",
            "message" => "Your card was declined.  You can call your bank for details.",
            "type" => "card_error"
          }
        }
      }
    end

    defp stripe_create_charge(_cents, _params) do
      mocked_stripe_resp()
    end

  else

    defp stripe_create_customer(params) do
      Stripe.Customers.create(params)
    end

    defp stripe_update_customer(id, params) do
      Stripe.Customers.update(id, params)
    end

    defp stripe_create_charge(cents, params) do
      Stripe.Charges.create(cents, params)
    end

  end
end
