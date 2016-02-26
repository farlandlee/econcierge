defmodule Grid.Admin.OrderView do
  use Grid.Web, :view

  @doc """
  Displays

    iex> quantity_display(%{"price_name" => "Adult", "quantity" => 3, "sub_total" => 100, "price_people_count" => 1})
    "Adult x 3 = $100 (3 people)"
  """
  def quantity_display(%{"price_name" => name, "quantity" => quantity, "sub_total" => sub_total, "price_people_count" => ppc}) do
    "#{name} x #{quantity} = $#{sub_total} (#{people(ppc * quantity)})"
  end

  defp people(1), do: "1 person"
  defp people(n), do: "#{n} people"
end
