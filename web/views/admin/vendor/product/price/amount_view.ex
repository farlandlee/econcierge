defmodule Grid.Admin.Vendor.Product.Price.AmountView do
  use Grid.Web, :view

  def sorted(amounts) do
    amounts
    |> Enum.sort(fn
      %{max_quantity: 0}, _ -> false
      _, %{max_quantity: 0} -> true
      a, b -> a.max_quantity < b.max_quantity
    end)
  end
end
