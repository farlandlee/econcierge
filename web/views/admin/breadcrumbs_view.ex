defmodule Grid.Admin.BreadcrumbsView do
  use Grid.Web, :view

  alias Phoenix.Naming

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

  defp parse_breadcrumbs([{action, module, model}], action, parsed, result) do
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

  defp path(parsed_resources) do
    path = parsed_resources
      |> Stream.map(&elem(&1, 0))
      |> Enum.reverse
      |> Enum.join("_")

    "admin_#{path}_path" |> String.to_existing_atom
  end

  defp resources(parsed_resources) do
    parsed_resources
    |> Enum.map(&elem(&1, 1))
    |> Enum.reverse
  end

  defp link_text(%{name: name}), do: name
  defp link_text(%{filename: filename}), do: filename
  defp link_text({_, module}), do: link_text(module)
  defp link_text(module) when is_atom(module), do: module.__schema__(:source) |> Naming.humanize

  defp create_breadcrumb({:show, module, model}, parsed) do
    parsed = [{resource_name(module), model} | parsed]
    link_fun = path(parsed)
    resources = [:show | resources(parsed)]

    breadcrumb = breadcrumb(model, link_fun, resources)
    {breadcrumb, parsed}
  end

  defp create_breadcrumb({:index, module}, parsed) do
    temp_parsed = [{resource_name(module), nil} | parsed]
    link_fun = path(temp_parsed)
    resources = [:index | resources(parsed)]

    breadcrumb = breadcrumb(module, link_fun, resources)
    {breadcrumb, parsed}
  end

  defp breadcrumb(module_or_model, link_fun, args) do
    text = module_or_model |> link_text
    path = apply_path(link_fun, args)

    {text, path}
  end


  defp apply_path(link_fun, args) do
    apply(
      Grid.Router.Helpers,
      link_fun,
      [Grid.Endpoint | args]
    )
  end
end
