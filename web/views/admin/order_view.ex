defmodule Grid.Admin.OrderView do
  use Grid.Web, :view

  @doc """
  Displays

    iex> quantity_display(%{"price_name" => "Adult", "quantity" => 3, "sub_total" => 100, "price_people_count" => 1})
    "Adult x 3 = $100 (3 people)"
  """
  def quantity_display(%{"price_name" => name, "quantity" => quantity, "sub_total" => sub_total, "price_people_count" => ppc}) do
    "#{name} x #{quantity} = #{number_to_currency(sub_total)} (#{people(ppc * quantity)})"
  end

  defp people(1), do: "1 person"
  defp people(n), do: "#{n} people"

  def items_with_status(order, status) do
    Enum.filter(order.order_items, &(&1.status == status))
  end

  def stripe_charge_link(text, nil) do
    text
  end

  def stripe_charge_link(text, charge_id) do
    link text,
      to: "https://dashboard.stripe.com/payments/#{charge_id}",
      target: "_blank",
      title: "View Charge in Stripe"
  end
end
