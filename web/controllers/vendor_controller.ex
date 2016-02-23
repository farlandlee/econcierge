defmodule Grid.VendorController do
  use Grid.Web, :controller

  alias Grid.Vendor

  def index(conn, _params) do
    vendors = Vendor
      |> Repo.alphabetical
      |> Repo.all
      |> Repo.preload(:default_image)
    render(conn, "index.html", vendors: vendors)
  end
end
