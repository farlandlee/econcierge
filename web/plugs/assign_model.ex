defmodule Grid.Plugs.AssignModel do

  alias Grid.Repo

  import Ecto, only: [assoc: 2]
  import Phoenix.Naming, only: [resource_name: 1]
  import Plug.Conn

  def init(model) when is_atom model do
    %{
      model: model,
      param: "id",
      as: assignment_name(model)
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

  def call(conn, %{model: model, param: param, as: as}) do
    assignment_id = conn.params[param]
    assignment = model
      |> constraint(conn)
      |> Repo.get!(assignment_id)

    assign(conn, as, assignment)
  end

  def assignment_name(module) do
    module
    |> resource_name
    |> String.to_existing_atom
  end

  defp constraint(Grid.Product, conn), do:
    assoc(conn.assigns.vendor, :products)

  defp constraint(Grid.StartTime, conn), do:
    assoc(conn.assigns.product, :start_times)

  defp constraint({"vendor_images", _}, conn), do:
    assoc(conn.assigns.vendor, :images)

  defp constraint({"activity_images", _}, conn), do:
    assoc(conn.assigns.activity, :images)

  defp constraint(model, _), do: model
end
