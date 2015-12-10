defmodule Grid.Router do
  use Grid.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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
    get "/activity/:activity_name", ActivityController, :show_by_name
    post "/activity", ActivityController, :show
  end

  scope "/admin", Grid.Admin, as: :admin do
    pipe_through :browser
    pipe_through :admin

    get "/", DashboardController, :index
    resources "/activities", ActivityController
    resources "/vendors", VendorController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Grid do
  #   pipe_through :api
  # end
end
