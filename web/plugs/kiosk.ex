defmodule Grid.Plugs.Kiosk do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    parts = String.split(conn.host, ".")
    sub_domain = hd(parts)

    if length(parts) > 2 && sub_domain != "book" do
      assign(conn, :kiosk, load_kiosk(sub_domain))
    else
      conn
    end
  end

  defp load_kiosk(sub_domain) do
    case Grid.Repo.get_by(Grid.Kiosk, sub_domain: sub_domain) do
      nil -> nil
      kiosk ->
        Grid.Repo.preload(kiosk, [:kiosk_sponsors, :vendor_activities])
    end
  end
end
