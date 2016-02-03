defmodule Grid.Plugs.AssignModel do

  alias Grid.Repo

  import Ecto, only: [assoc: 2]
  import Ecto.Query, only: [preload: 2]
  import Phoenix.Naming, only: [resource_name: 1]
  import Plug.Conn

  def init(model) when is_atom model do
    %{
      model: model,
      param: "id",
      as: assignment_name(model),
      preload: []
    }
  end

  # init for abstract models
  def init(table = {_, model}) do
    %{init(model) | model: table}
  end

  def init(options) when is_list options do
    options = Enum.into(options, %{})
    defaults = Map.fetch!(options, :model)
      |> init

    Map.merge(defaults, options)
  end

  def call(conn, %{model: model, param: param, as: as, preload: preload}) do
    assignment_id = conn.params[param]
    assignment = model
      |> constraint(conn)
      |> preload(^preload)
      |> Repo.get!(assignment_id)

    assign(conn, as, assignment)
  end

  def assignment_name(module) do
    module
    |> resource_name
    |> String.to_existing_atom
  end

  defp constraint(Grid.VendorActivity, conn), do:
    assoc(conn.assigns.vendor, :vendor_activities)

  defp constraint(Grid.Product, conn), do:
    assoc(conn.assigns.vendor, :products)

  defp constraint(Grid.Price, conn), do:
    assoc(conn.assigns.product, :prices)

  defp constraint(Grid.StartTime, conn), do:
    assoc(conn.assigns.product, :start_times)

  defp constraint(Grid.Category, conn), do:
    assoc(conn.assigns.activity, :categories)

  defp constraint({table, Grid.Image}, conn) do
    assign = table |> String.split("_") |> hd |> String.to_existing_atom
    assoc(conn.assigns[assign], :images)
  end

  defp constraint(model, _), do: model
end
