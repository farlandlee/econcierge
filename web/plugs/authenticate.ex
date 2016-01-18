defmodule Grid.Plugs.Authenticate do
  alias Grid.Router.Helpers

  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _) do
    case conn.assigns.current_user do
      nil ->
        conn
        |> put_flash(:error, "You must be signed in to see that.")
        |> redirect(to: Helpers.auth_path(conn, :index))
        |> halt
      _ -> conn
    end
  end
end
