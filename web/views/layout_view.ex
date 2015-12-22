defmodule Grid.LayoutView do
  use Grid.Web, :view
  import Phoenix.Controller, only: [controller_module: 1, get_flash: 2]

  def nav_class(conn, controllers) when is_list(controllers) do
    if controller_module(conn) in controllers do
      "active"
    else
      ""
    end
  end
  def nav_class(conn, controller), do: nav_class(conn, [controller])
end
