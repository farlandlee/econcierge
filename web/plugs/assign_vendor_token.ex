defmodule Grid.Plugs.AssignVendorToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn = %{params: %{"vendor_token" => vt}}, _) do
    assign(conn, :vendor_token, String.slice(vt, 0..7))
  end
end
