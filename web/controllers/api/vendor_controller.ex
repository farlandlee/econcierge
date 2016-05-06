defmodule Grid.Api.VendorController do
  use Grid.Web, :controller

  alias Grid.Vendor

  def index(conn, params) do
    vendors = Vendor.having_published_products
      |> Repo.all_in_ids(params["ids"])
      |> Repo.preload(:default_image)

    render(conn, "index.json", vendors: vendors)
  end

  def show(conn, %{"id" => id}) do
    vendor = Repo.get!(Vendor, id) |> Repo.preload(:default_image)
    render(conn, "show.json", vendor: vendor)
  end
end
