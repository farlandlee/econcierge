defmodule Grid.Plugs.KioskTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Grid.{
    Factory,
    Plugs
  }

  setup do
    kiosk = Factory.create(:kiosk)
    {:ok, kiosk: kiosk}
  end

  test "no kiosk at localhost" do
    conn = Plugs.Kiosk.call(%Plug.Conn{host: "localhost"}, nil)
    refute Map.has_key?(conn.assigns, :kiosk)
  end

  test "no kiosk on regular url" do
    conn = Plugs.Kiosk.call(%Plug.Conn{host: "book.outpostjh.com"}, nil)
    refute Map.has_key?(conn.assigns, :kiosk)
  end

  test "has kiosk", %{kiosk: kiosk} do
    conn = Plugs.Kiosk.call(%Plug.Conn{host: "#{kiosk.sub_domain}.outpostjh.com"}, nil)
    assert conn.assigns[:kiosk].id == kiosk.id
  end
end
