defmodule Grid.Plugs.AssignModel do

  alias Grid.Repo
  alias Grid.Product

  import Ecto.Query
  import Phoenix.Naming, only: [resource_name: 1]
  import Plug.Conn

  def init(model) when is_atom model do
    %{
      model: model,
      param: "id",
      as: model |> resource_name |> String.to_existing_atom
    }
  end

  # init for abstract models
  def init(table = {_, model}) do
    %{init(model) | model: table}
  end

  def init(options) when is_list options do
    defaults = Keyword.fetch!(options, :model)
      |> init

    %{
      param: Keyword.get(options, :param, defaults.param),
      as: Keyword.get(options, :as, defaults.as),
      model: defaults.model
    }
  end

  def call(conn, opts) do
    assignment = opts.model
      |> constraint(opts.model, conn)
      |> Repo.get!(conn.params[opts.param])

    assign(conn, opts.as, assignment)
  end

  defp constraint(query, Grid.Product, conn), do:
    where(query, vendor_id: ^conn.assigns.vendor.id)

  defp constraint(query, Grid.StartTime, conn), do:
    where(query, product_id: ^conn.assigns.product.id)

  defp constraint(query, {"vendor_images", _}, conn), do:
    where(query, assoc_id: ^conn.assigns.vendor.id)

  defp constraint(query, {"activity_images", _}, conn), do:
    where(query, assoc_id: ^conn.assigns.activity.id)

  defp constraint(query, _, _), do: query

end
