defmodule Grid.Admin.Vendor.Product.PriceView do
  use Grid.Web, :view

  def format_form_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn
      {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
      msg -> msg
    end)
    |> Enum.map(fn {attr, message} -> {humanize(attr), message} end)
  end
end
