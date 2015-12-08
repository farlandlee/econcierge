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
    get "/activities", PageController, :activities
  end

  scope "/admin", Grid.Admin do
    pipe_through :browser
    pipe_through :admin

    resources "/activities", ActivityController
    resources "/vendors", VendorController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Grid do
  #   pipe_through :api
  # end
end
