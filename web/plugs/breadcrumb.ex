defmodule Grid.Plugs.Breadcrumb do
  import Plug.Conn

  @priv_key :grid_resource_breadcrumbs

  defstruct action: nil, model: nil

  defp breadcrumb(conn, module, model) do
    breadcrumbs = Map.get(conn.private, :grid_resource_breadcrumbs, [])
    breadcrumbs = [{:show, module, model}, {:index, module} | breadcrumbs]
    put_private(conn, :grid_resource_breadcrumbs, breadcrumbs)
  end


  def init(show: module) when is_atom module do
    [%__MODULE__{action: :show, model: module}]
  end

  def init(index: module) when is_atom module do
    [%__MODULE__{action: :index, model: module}]
  end

  def init(resource: module) when is_atom module do
    [
      %__MODULE__{action: :index, model: module},
      %__MODULE__{action: :show, model: module}
    ]
  end

  def call(conn, crumbs) do
    conn |> put_breadcrumbs(crumbs)
  end

  defp put_breadcrumbs(conn, [crumb | crumbs]) do
    conn
    |> put_breadcrumb(crumb)
    |> put_breadcrumbs(crumbs)
  end

  defp put_breadcrumbs(conn, []) do
    conn
  end

  defp put_breadcrumb(conn, crumb) do
    crumb = update_model(conn, crumb)

    crumbs = [crumb | Map.get(conn.private, :grid_resource_breadcrumbs, [])]

    put_private(conn, :grid_resource_breadcrumbs, crumbs)
  end

  defp update_model(conn, %{action: :show, model: module} = crumb) do
    assignment_name = Grid.Plugs.AssignModel.assignment_name(module)
    %{crumb | model: conn.assigns[assignment_name]}
  end

  defp update_model(_, crumb) do
    crumb
  end
end
