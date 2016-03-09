defmodule Grid.Cart do
  alias Grid.{
    Repo,
    Product
  }

  @doc """
  Converts a shopping cart payload into parameters that are valid for creating
  an `Order` the its nested list of `OrderItem` entries.
  """
  def to_order_params(items = [_|_]) do
    {order_items, total} = Enum.map_reduce(items, 0, fn
      (%{"product" => p} = item, acc) ->
        case extract_order_item(item) do
          {:ok, oi_params} ->
            {oi_params, acc + oi_params.amount}

          {:error, error} -> throw(%{product: p, message: error})
        end
      (_, _) -> throw(%{message: "No product id"})
    end)

    {:ok, %{total_amount: total, order_items: order_items}}
  catch
    error -> {:error, error}
  end
  def to_order_params(_), do: {:error, "No items in cart"}

  def extract_order_item(%{"product" => p_id} = items) do
    product = Repo.get(Product, p_id)
    extract_for_product(items, product)
  end
  def extract_order_item(_), do: {:error, "Invalid cart item"}

  def extract_for_product(_, nil), do: {:error, "Could not find product"}
  def extract_for_product(%{"startTime" => %{"id" => st_id}} = items, product) do
    product = Repo.preload(product, start_times: :season, prices: :amounts)

    start_time = Enum.find(product.start_times, fn(t) ->
      t.id == st_id #TODO: could add more validation here to verify date and dotw
    end)

    extract_for_start_time(items, product, start_time)
  end
  def extract_for_product(_, _), do: {:error, "No start time supplied"}

  def extract_for_start_time(_, _, nil), do: {:error, "Could not find start_time"}
  def extract_for_start_time(%{"date" => date, "quantities" => quants}, product, start_time) do
    activity_at = Ecto.DateTime.from_date_and_time(
      Ecto.Date.cast!(date),
      start_time.starts_at_time
    )

    case extract_quantities(quants, product.prices) do
      {:ok, quantities, sub_total} ->
        {:ok, %{
          product_id: product.id,
          activity_at: activity_at,
          amount: sub_total,
          quantities: %{"items" => quantities}
        }}
      {:error, error} -> {:error, error}
    end
  end
  def extract_for_start_time(_, _, _), do: {:error, "Date or quantities not supplied"}


  def extract_quantities(quants, prices = [_|_]) do
    quants = Enum.filter(quants, fn
      %{"quantity" => 0} -> false
      _ -> true
    end)

    {params, sub_total} = Enum.map_reduce(quants, 0, fn(q, acc) ->
      case extract_quantity(q, prices) do
        {:ok, params} -> {params, acc + params["sub_total"]}
        {:error, error} -> throw(error)
      end
    end)

    {:ok, params, sub_total}
  catch
    error -> {:error, error}
  end
  def extract_quantities(_, _), do: {:error, "No prices found for product"}

  def extract_quantity(%{"id" => pid} = quantity, prices) do
    price = Enum.find(prices, &(&1.id == pid))
    extract_with_price(quantity, price)
  end
  def extract_quantity(_, _), do: {:error, "No price id included in quantity"}

  def extract_with_price(_, nil), do: {:error, "Price not found"}
  def extract_with_price(%{"quantity" => quantity} = q_params, price) do
    amount = Enum.find(price.amounts, fn(a) ->
      a.min_quantity <= quantity &&
      (a.max_quantity >= quantity || a.max_quantity == 0)
    end)

    extract_with_amount(q_params, price, amount)
  end
  def extract_with_price(_, _), do: {:error, "Quantity not included"}

  def extract_with_amount(_, _, nil), do: {:error, "Amount not found"}
  def extract_with_amount(%{"cost" => cost, "quantity" => quantity}, price, amount) do
    total = amount.amount * quantity
    if total == cost do
      {:ok, %{
        "price_id" => price.id,
        "sub_total" => cost,
        "quantity" => quantity,
        "price_name" => price.name,
        "price_people_count" => price.people_count
      }}
    else
      {:error, "Quantity cost is invalid for price: #{price.id}"}
    end
  end
  def extract_with_amount(_, _, _), do: {:error, "Cost not included"}
end
