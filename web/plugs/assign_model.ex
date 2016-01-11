defmodule Grid.Plugs.AssignModel do

  alias Grid.Repo

  import Ecto, only: [assoc: 2]
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
    assignment = constraint(opts.model, conn)
      |> Repo.get!(conn.params[opts.param])

    assign(conn, opts.as, assignment)
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