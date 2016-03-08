defmodule Grid.Stripe do
  use GenServer

  #########
  ## API ##
  #########

  def link_customer(customer, stripe_token), do:
    GenServer.cast(__MODULE__, {:link_customer, %{customer: customer, source: stripe_token}})

  def charge_customer(order_item), do:
    GenServer.cast(__MODULE__, {:charge_customer, order_item})

  #########################
  ## GenServer Callbacks ##
  #########################

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, %{}}
  end

  if Mix.env() == :test do
    def handle_cast({:link_customer, _}, state) do
      {:noreply, state}
    end

    def handle_cast({:charge_customer, _}, state) do
      {:noreply, state}
    end
  end

  if Mix.env() != :test do
    @doc """
    Will create a new customer in stripe and link that customer to our local user.
    If the user has aleady been linked, then we update the stripe credit card
    "source".
    """
    def handle_cast({:link_customer, %{customer: %{stripe_id: nil} = customer, source: stripe_token}}, state) do
      {:ok, %{id: id}} = Stripe.Customers.create([
        email: customer.email,
        description: customer.name,
        source: stripe_token
      ])

      Grid.User.changeset(customer, %{stripe_id: id})
      |> Grid.Repo.update!

      {:noreply, state}
    end
    def handle_cast({:link_customer, %{customer: %{stripe_id: id}, source: stripe_token}}, state) do
      {:ok, _} = Stripe.Customers.update(id, [source: stripe_token])

      {:noreply, state}
    end

    @doc """
    Charte customer for the order item amount.
    """
    def handle_cast({:charge_customer, %Grid.OrderItem{} = order_item}, state) do
      order_item
      = %{order: %{user: user}, product: product}
      = Grid.Repo.preload(order_item, [order: :user, product: :vendor])

      params = [
        customer: user.stripe_id,
        description: String.replace("#{product.name} - #{product.vendor.name}", "&", "%26")
      ]

      cents = round(order_item.amount * 100)

      {:ok, %{id: id}} = Stripe.Charges.create(cents, params)

      Grid.OrderItem.charge_changeset(order_item, id)
      |> Grid.Repo.update!

      {:noreply, state}
    end
  end
end
