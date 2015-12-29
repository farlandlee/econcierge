defmodule Grid.Router do
  use Grid.Web, :router

  alias Grid.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :assign_vendor do
    plug Plugs.AssignModel, Grid.Vendor
  end

  pipeline :admin do
    plug :put_layout, {Grid.LayoutView, "admin.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Grid do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    post "/activity", ActivityController, :show
    get "/activity/:activity_name", ActivityController, :show_by_name
    get "/activity/:activity_name/:category_name", ActivityController, :show_by_name_and_category
  end

  scope "/admin", Grid.Admin, as: :admin do
    pipe_through :browser
    pipe_through :admin

    get "/", DashboardController, :index

    resources "/activities", ActivityController
    resources "/categories", CategoryController

    resources "/vendors", VendorController, [alias: Vendor] do
      pipe_through :assign_vendor

      resources "/images", ImageController
      put "/images/:id/default", ImageController, :set_default

      resources "/products", ProductController
    end
  end
end
