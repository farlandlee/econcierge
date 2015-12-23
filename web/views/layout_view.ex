defmodule Grid.LayoutView do
  use Grid.Web, :view
  import Phoenix.Controller, only: [controller_module: 1, get_flash: 2]

  alias Phoenix.Naming

  def nav_class(conn, controller) when is_atom(controller) do
    match = controller |> Naming.unsuffix("Controller")
    conn
    |> controller_module
    |> Atom.to_string
    |> String.starts_with?(match)
    |> if(do: "active", else: "")
  end

end
