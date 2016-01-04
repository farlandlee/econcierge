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

  def call(conn, %{model: Grid.Product}=opts) do
    product = Grid.Product
      |> where(vendor_id: ^conn.assigns.vendor.id)
      |> Repo.get!(conn.params[opts.param])

    assign(conn, opts.as, product)
  end

  def call(conn, %{model: Grid.StartTime}=opts) do
    start_time = Grid.StartTime
      |> where(product_id: ^conn.assigns.product.id)
      |> Repo.get!(conn.params[opts.param])

    assign(conn, opts.as, start_time)
  end

  def call(conn, %{model: {"vendor_images", _}=t}=opts) do
    image = t
      |> where(assoc_id: ^conn.assigns.vendor.id)
      |> Repo.get!(conn.params[opts.param])

    assign(conn, opts.as, image)
  end

  def call(conn, options) do
    id = conn.params[options.param]
    model = Repo.get!(options.model, id)
    assign(conn, options.as, model)
  end
end
