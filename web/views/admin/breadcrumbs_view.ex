defmodule Grid.Admin.BreadcrumbsView do
  use Grid.Web, :view

  alias Phoenix.Naming
  alias Grid.Router.Helpers

  alias Grid.VendorActivity, as: VA

  alias Grid.Plugs.Breadcrumb, as: Crumb

  def crumb(breadcrumb)
  def crumb({text, path}) do
    content_tag :li, link(text, to: path)
  end
  def crumb(text) do
    content_tag :li, text, class: "active"
  end

  ### The meat

  def breadcrumbs(conn) do
    resource_breadcrumbs = conn.private[:grid_resource_breadcrumbs]
    action = Phoenix.Controller.action_name(conn)
    create_breadcrumbs(resource_breadcrumbs, action)
  end

  defp create_breadcrumbs(nil, _), do: []
  defp create_breadcrumbs(crumbs, action) do
    crumbs
    |> Enum.reverse
    |> parse_breadcrumbs(action, [], [])
  end

  defp parse_breadcrumbs([%Crumb{action: action, model: model}], action, parsed, result) do
    # Don't make a link for the last crumb if it's our current action.
    text = link_text(model)
    parse_breadcrumbs([], action, parsed, [text | result])
  end

  defp parse_breadcrumbs([crumb | crumbs], action, parsed, result) do
    {breadcrumb, parsed} = create_breadcrumb crumb, parsed
    parse_breadcrumbs(crumbs, action, parsed, [breadcrumb | result])
  end

  defp parse_breadcrumbs([], _, _, result) do
    result |> Enum.reverse
  end

  defp resource_name({_table, module}), do: resource_name(module)
  defp resource_name(module), do: Naming.resource_name(module)

  defp path(crumbs) do
    path = crumbs
      |> Stream.filter(&(is_atom(&1.model)))
      |> Stream.map(&(&1.model))
      |> Stream.map(&resource_name/1)
      |> Enum.reverse
      |> Enum.join("_")

    "admin_#{path}_path" |> String.to_existing_atom
  end

  defp resources(parsed_resources) do
    parsed_resources
    |> Stream.reject(&(is_atom(&1.model)))
    |> Stream.map(&(&1.model))
    |> Enum.reverse
  end

  defp link_text(%{name: name}), do: name
  defp link_text(%{filename: filename}), do: filename
  defp link_text(%VA{activity: a}), do: link_text(a)
  defp link_text({_, module}), do: link_text(module)
  defp link_text(module) when is_atom(module), do: module.__schema__(:source) |> Naming.humanize

  defp create_breadcrumb(%Crumb{action: action, model: model} = crumb, parsed) do
    parsed = [crumb | parsed]
    path_fun = path(parsed)
    path_args = [action | resources(parsed)]

    breadcrumb = breadcrumb(model, path_fun, path_args)
    {breadcrumb, parsed}
  end

  defp breadcrumb(module_or_model, path_fun, args) do
    text = module_or_model |> link_text
    path = apply(Helpers, path_fun, [Grid.Endpoint | args])

    {text, path}
  end
end
