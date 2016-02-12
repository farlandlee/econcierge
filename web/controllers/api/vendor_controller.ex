defmodule Grid.Api.VendorController do
  use Grid.Web, :controller

  alias Grid.Vendor

  def index(conn, _) do
    vendors = Vendor.having_published_products |> Repo.all
    render(conn, "index.json", vendors: vendors)
  end

  def show(conn, %{"id" => id}) do
    vendor = Repo.get!(Vendor, id)
    render(conn, "show.json", vendor: vendor)
  end
end
