defmodule Grid.LayoutView do
  use Grid.Web, :view
  import Phoenix.Controller, only: [controller_module: 1, get_flash: 2]

  def nav_class(conn, controller) do
    case controller_module(conn) do
      ^controller -> "active"
      _ -> ""
    end
  end
end
