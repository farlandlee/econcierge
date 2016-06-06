defmodule Grid.Plugs.AssignGoogleToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    token = get_session(conn, :ga_access_token) ||
            conn.assigns[:ga_access_token] # for tests
            
    assign(conn, :ga_access_token, token)
  end
end
