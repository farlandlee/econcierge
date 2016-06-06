defmodule Grid.Plugs.Authenticate do
  alias Grid.Router.Helpers

  import Plug.Conn
  import Phoenix.Controller

  def init(args), do: args

  def call(conn, _) do
    if conn.assigns.current_user == nil || conn.assigns.ga_access_token == nil do
      conn
      |> put_flash(:error, "You must be signed in to see that.")
      |> put_session(:redirected_from, conn.request_path)
      |> redirect(to: Helpers.auth_path(conn, :index))
      |> halt
    else
      conn
    end
  end
end
