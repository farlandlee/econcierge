defmodule Grid.Router do
  use Grid.Web, :router

  alias Grid.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plugs.AssignUser
  end

  pipeline :assign_vendor do
    plug Plugs.AssignModel, model: Grid.Vendor, param: "vendor_id"
  end

  pipeline :assign_product do
    plug Plugs.AssignModel, model: Grid.Product, param: "product_id"
  end

  pipeline :assign_activity do
    plug Plugs.AssignModel, model: Grid.Activity, param: "activity_id"
  end

  pipeline :admin do
    plug :put_layout, {Grid.LayoutView, "admin.html"}
    plug Plugs.Authenticate
  end

  scope "/", Grid do
    pipe_through :browser

    get "/", PageController, :index

    scope "/browse" do
      post "/", ActivityController, :show
      scope "/:activity_slug" do
        get "/vendors", ActivityController, :vendors_by_activity_slug
        get "/experiences", ActivityController, :experiences_by_activity_slug
        scope "/:category_slug" do
          get "/vendors", ActivityController, :vendors_by_activity_and_category_slugs
          get "/experiences", ActivityController, :experiences_by_activity_and_category_slugs
        end
      end
    end
  end

  scope "/auth", Grid do
    pipe_through :browser

    get "/", AuthController, :index
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :login
    get "/:provider/callback", AuthController, :callback
  end

  scope "/admin", Grid.Admin, as: :admin do
    pipe_through :browser
    pipe_through :admin

    get "/", DashboardController, :index

    get "/users", UserController, :index

    resources "/activities", ActivityController, [alias: Activity] do
      pipe_through :assign_activity

      resources "/experiences", ExperienceController, except: [:show]

      resources "/images", ImageController, except: [:index]
      put "/images/:id/default", ImageController, :set_default
    end

    resources "/categories", CategoryController, except: [:show]

    resources "/vendors", VendorController, [alias: Vendor] do
      pipe_through :assign_vendor

      resources "/images", ImageController, except: [:index]
      put "/images/:id/default", ImageController, :set_default

      resources "/products", ProductController, [alias: Product, except: [:index]] do
        pipe_through :assign_product

        resources "/start_times", StartTimeController, only: [:create, :delete]

        resources "/prices", PriceController, except: [:index, :show]
        put "/prices/:id/default", PriceController, :set_default
      end
    end
  end
end
