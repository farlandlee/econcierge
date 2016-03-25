defmodule Grid.Cart do
  alias Grid.{
    CartError,
    Repo,
    Product
  }

  @doc """
  Converts a shopping cart payload into parameters that are valid for creating
  an `Order` the its nested list of `OrderItem` entries.
  """
  def to_order_params!([]) do
    raise CartError, message: "No items in cart"
  end

  def to_order_params!(items) do
    {order_items, total} = Enum.map_reduce(items, 0, fn item, acc ->
      case extract_order_item(item) do
        {:ok, oi_params} -> {oi_params, acc + oi_params.amount}
        {:error, error} -> raise CartError, message: error, product: item["product"]
      end
    end)

    %{total_amount: total, order_items: order_items}
  end
  @doc """
  Starts with something like
  %{
    product: p.id,
    date: two_days_from_now,
    startTime: %{ id: st.id },
    quantities: [%{
      id: price.id,
      quantity: 3,
      cost: amount.amount * 3
    }, %{
      id: price2.id,
      quantity: 0,
      cost: 0
    }]
  }
  ends with this
  %{
    product_id: product.id,
    activity_at: activity_at,
    amount: sub_total,
    quantities: %{"items" => quantities}
  }
  """
  def extract_order_item(item) do
    with {:ok, product} <- load_product(item),
         {:ok, activity_at} <- calculate_activity_at(item, product),
         {:ok, quantities, subtotal} <- extract_quantities(item, product),
      do: {:ok, %{
            product_id: product.id,
            activity_at: activity_at,
            amount: subtotal,
            quantities: %{"items" => quantities}
          }}
  end

  #################
  ##   product   ##
  #################

  defp load_product(%{"product" => product_id}) do
    # @TODO only allow published products
    case Repo.get(Product, product_id) do
      nil -> {:error, "Could not find product"}
      product ->
        product = Repo.preload(product, start_times: :season, prices: :amounts)
        {:ok, product}
    end
  end

  defp load_product(_) do
    {:error, "No product id"}
  end

  #################
  ## activity_at ##
  #################

  defp calculate_activity_at(item = %{"startTime" => %{"id" => start_time_id}}, product) do
    #TODO: could add more validation here to verify date and dotw
    product.start_times
    |> Enum.find(&(&1.id == start_time_id))
    |> do_calculate_activity_at(item["date"])
  end

  defp calculate_activity_at(_, _) do
    {:error, "No start time supplied"}
  end

  defp do_calculate_activity_at(start_time, date)
  when is_nil(start_time) or is_nil(date) do
    error = cond do
      start_time -> "Date not supplied"
      date       -> "Could not find start_time"
      :both_nil  -> ["Could not find start_time", "Date not supplied"]
    end
    {:error, error}
  end

  defp do_calculate_activity_at(%{starts_at_time: time}, date) do
    activity_at = date
      |> Ecto.Date.cast!
      |> Ecto.DateTime.from_date_and_time(time)
    {:ok, activity_at}
  end

  #####################
  ##    Quantities   ##
  #####################

  def extract_quantities(%{"quantities" => quants}, %{prices: prices = [_|_]}) do
    quants = Enum.reject(quants, &(&1["quantity"] == 0))

    {params, sub_total} = Enum.map_reduce(quants, 0, fn q, acc ->
      case extract_quantity(q, prices) do
        {:ok, quantity} -> {quantity, acc + quantity["sub_total"]}
        {:error, error} -> throw(error)
      end
    end)

    {:ok, params, sub_total}
  catch
    error -> {:error, error}
  end

  def extract_quantities(%{"quantities" => _}, _) do
    {:error, "No prices found for product"}
  end

  def extract_quantities(_, _) do
    {:error, "No quantities provided"}
  end

  ####################
  ##    Quantity    ##
  ####################

  def extract_quantity(quantity, prices) do
    with {:ok, price} <- extract_quantity_price(quantity, prices),
         {:ok, amount} <- extract_quantity_price_amount(quantity, price),
         {:ok, cost} <- calculate_quantity_cost(quantity, amount),
         :ok <- verify_calculated_cost(quantity, cost, price),
      do: {:ok, %{
            "price_id" => price.id,
            "sub_total" => cost,
            "quantity" => quantity["quantity"],
            "price_name" => price.name,
            "price_people_count" => price.people_count
          }}
  end

  defp extract_quantity_price(%{"id" => price_id}, prices) do
    case Enum.find(prices, &(&1.id == price_id)) do
      nil -> {:error, "Price not found"}
      price -> {:ok, price}
    end
  end

  defp extract_quantity_price(_, _) do
    {:error, "No price id included in quantity"}
  end

  defp extract_quantity_price_amount(%{"quantity" => quantity}, %{amounts: amounts}) do
    amount = Enum.find(amounts, fn %{min_quantity: min, max_quantity: max} ->
      min <= quantity && (max >= quantity || max == 0)
    end)
    case amount do
      nil -> {:error, "Amount not found"}
      amount -> {:ok, amount}
    end
  end

  defp extract_quantity_price_amount(_, _) do
    {:error, "Quantity not included"}
  end

  defp calculate_quantity_cost(%{"quantity" => quantity}, %{amount: amount}) do
    {:ok, quantity * amount}
  end

  defp verify_calculated_cost(%{"cost" => client}, expected, price) do
    if client == expected do
      :ok
    else
      {:error, "Quantity cost is invalid for price: #{price.id}"}
    end
  end

  defp verify_calculated_cost(_, _, _) do
    {:error, "Cost not included"}
  end
end
