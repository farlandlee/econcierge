defmodule Grid.Plugs.AssignModel do
  import Plug.Conn
  alias Grid.Repo
  import Phoenix.Naming, only: [resource_name: 1]

  def init(module) when is_atom module do
    name = resource_name(module)

    param = "#{name}_id"
    as = name |> String.to_existing_atom

    %{
      param: param,
      as: as,
      module: module
    }
  end

  # init for abstract models
  def init(table = {_, module}) do
    %{init(module) | module: table}
  end

  def init(options) when is_list options do
    defaults = options
      |> Keyword.fetch!(:module)
      |> init

    %{
      param: Keyword.get(options, :param, defaults.param),
      as: Keyword.get(options, :as, defaults.as),
      module: defaults.module
    }
  end

  def call(conn, options) do
    id = conn.params[options.param]
    model = Repo.get!(options.module, id)
    assign(conn, options.as, model)
  end
end
