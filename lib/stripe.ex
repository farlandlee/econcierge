defmodule Grid.Stripe do
  use GenServer
  require Logger

  #########################
  ## GenServer Callbacks ##
  #########################

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def link_customer(customer, stripe_token), do:
    GenServer.cast(__MODULE__, {:link_customer, %{customer: customer, source: stripe_token}})

  def init([]) do
    {:ok, %{}}
  end

  if Mix.env() == :test do
    def handle_cast({:link_customer, _}, state) do
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
  end
end
