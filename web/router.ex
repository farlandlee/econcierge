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

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :put_layout, {Grid.LayoutView, "admin.html"}
    plug Plugs.Authenticate
  end

  pipeline :assign_vendor do
    plug Plugs.AssignModel, model: Grid.Vendor, param: "vendor_id"
    plug Plugs.Breadcrumb, resource: Grid.Vendor
  end
  pipeline :assign_vendor_activity do
    plug Plugs.AssignModel, model: Grid.VendorActivity, param: "vendor_activity_id",
      preload: :activity
    plug Plugs.Breadcrumb, resource: Grid.VendorActivity
  end
  pipeline :assign_product do
    plug Plugs.AssignModel, model: Grid.Product, param: "product_id"
    plug Plugs.Breadcrumb, resource: Grid.Product
  end
  pipeline :assign_product_price do
    plug Plugs.AssignModel, model: Grid.Price, param: "price_id"
    plug Plugs.Breadcrumb, resource: Grid.Price
  end
  pipeline :assign_activity do
    plug Plugs.AssignModel, model: Grid.Activity, param: "activity_id"
    plug Plugs.Breadcrumb, resource: Grid.Activity
  end
  pipeline :assign_amenity do
    plug Plugs.AssignModel, model: Grid.Amenity, param: "amenity_id"
    plug Plugs.Breadcrumb, resource: Grid.Amenity
  end


  scope "/", Grid do
    pipe_through :browser

    get "/", PageController, :index

    get "/explore/:activity_slug/:category_slug/:date/*path", ExploreController, :index
    get "/explore/:activity_slug/:category_slug", ExploreController, :without_date

    scope "/browse" do
      post "/", ActivityController, :show
      get "/:activity_slug/categories", ActivityController, :categories_by_activity_slug
    end

    get "/500", ErrorController, :render_500
    get "/404", ErrorController, :render_404
  end

  scope "/auth", Grid do
    pipe_through :browser

    get "/", AuthController, :index
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :login
    get "/:provider/callback", AuthController, :callback
  end

  scope "/web_api", Grid.Api, as: :api do
    pipe_through :api

    get "/activities", ActivityController, :index
    get "/activities/:slug", ActivityController, :show

    get "/categories", CategoryController, :index
    get "/categories/:slug", CategoryController, :show

    get "/experiences", ExperienceController, :index
    get "/experiences/:slug", ExperienceController, :show

    get "/products", ProductController, :index
    get "/products/:id", ProductController, :show

    get "/vendor", VendorController, :index
    get "/vendor/:id", VendorController, :show
  end

  scope "/admin", Grid.Admin, as: :admin do
    pipe_through [:browser, :admin]

    get "/", DashboardController, :index

    get "/users", UserController, :index

    resources "/activities", ActivityController, [alias: Activity] do
      pipe_through :assign_activity

      resources "/amenities", AmenityController, [alias: Amenity] do
        pipe_through :assign_amenity

        resources "/amenity_options", AmenityOptionController
      end

      resources "/categories", CategoryController

      resources "/experiences", ExperienceController

      resources "/images", ImageController
      put "/images/:id/default", ImageController, :set_default
    end


    get "/vendors/:id/refresh", VendorController, :refresh
    resources "/vendors",   VendorController, [alias: Vendor] do
      pipe_through :assign_vendor

      resources "/activities", VendorActivityController, [except: [:edit, :update], alias: VendorActivity] do
        pipe_through :assign_vendor_activity
        resources "/seasons", SeasonController
      end

      resources "/locations", LocationController

      resources "/images", ImageController
      put "/images/:id/default", ImageController, :set_default

      get "/products/:id/clone", ProductController, :clone
      resources "/products", ProductController, [alias: Product] do
        pipe_through :assign_product

        resources "/start_times", StartTimeController

        put "/prices/:id/default", PriceController, :set_default
        resources "/prices", PriceController, [alias: Price] do
          pipe_through :assign_product_price
          resources "/amounts", AmountController
        end
      end
    end
  end
end
