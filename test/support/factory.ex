defmodule Grid.Factory do
  use ExMachina.Ecto, repo: Grid.Repo

  import Ecto

  alias Grid.Repo

  # Models we factorize!
  alias Grid.{
    Amount,
    Activity,
    Amenity,
    AmenityOption,
    Category,
    Coupon,
    Experience,
    ExperienceCategory,
    Location,
    Order,
    Price,
    Product,
    Season,
    StartTime,
    User,
    Vendor,
    VendorActivity
  }

  def random(), do: :random.uniform()
  def random(n), do: :random.uniform(n)

  def factory(:coupon) do
    %Coupon{
      code: sequence(:code, &"CODE_#{&1}"),
      expiration_date: %Ecto.Date{year: 2017, month: 1, day: 1},
      usage_count: 0,
      max_usage_count: nil,
      percent_off: 10 + random(80),
      disabled: false
    }
  end

  def factory(:user) do
    %User{
      name: sequence(:name, &"user-#{&1}"),
      email: sequence(:email, &"email.#{&1}@outpostjh.com"),
      phone: sequence(:phone, &"phone-#{&1}")
    }
  end

  def factory(:location) do
    %Location{
      name: sequence(:name, &"location-#{&1}"),
      address1: sequence(:address, &"#{&1} Main St."),
      address2: sequence(:address, &"Apt #{&1}"),
      city: sequence(:address, &"city-#{&1}"),
      state: Enum.random(Grid.USStates.codes()),
      zip: sequence(:address, &"zip-#{&1}"),
      vendor: build(:vendor)
    }
  end

  def factory(:amount) do
    %Amount{
      price: build(:price),
      amount: (:random.uniform() * 1000) |> Float.floor(2),
      max_quantity: 0
    }
  end

  def factory(:price) do
    %Price{
      product: build(:product),
      people_count: 1,
      name: sequence(:name, &"price-#{&1}"),
      description: sequence(:description, &"Too much moneys by: #{&1}")
    }
  end

  def factory(:start_time) do
    raise ArgumentError, message: """
    Cannot create start times from factory. See `create_start_time` instead
    """
  end

  def factory(:amenity) do
    %Amenity{
      activity: build(:activity),
      name: sequence(:name, &"amentity-#{&1}")
    }
  end

  def factory(:amenity_option) do
    %AmenityOption{
      amenity: build(:amenity),
      name: sequence(:name, &"amentity-option-#{&1}")
    }
  end

  def factory(:category) do
    %Category{
      activity: build(:activity),
      name: sequence(:name, &"category-#{&1}"),
      description: sequence(:description, &"category-#{&1}"),
      slug: sequence(:slug, &"category-#{&1}")
    }
  end

  def factory(:vendor_image) do
    build_image(%Vendor{})
  end

  def factory(:product_image) do
    build_image(%Product{})
  end

  def factory(:activity_image) do
    build_image(%Activity{})
  end

  def factory(:activity) do
    %Activity{
      name: sequence(:name, &"activity-#{&1}"),
      description: "Something fun!",
      slug: sequence(:slug, &"activity-#{&1}")
    }
  end

  def factory(:experience) do
    %Experience{
      name: sequence(:name, &"exerience-#{&1}"),
      description: "Mind Expanding!",
      slug: sequence(:slug, &"experience-#{&1}"),
      activity: build(:activity)
    }
  end

  def factory(:experience_category) do
    %ExperienceCategory{
      experience: build(:experience),
      category: build(:category)
    }
  end

  def factory(:vendor) do
    %Vendor{
      name: sequence(:name, &"vendor-#{&1}"),
      slug: sequence(:slug, &"vendor-#{&1}"),
      description: "The best! #{random()}"
    }
  end

  def factory(:vendor_activity) do
    %VendorActivity{
      vendor: build(:vendor),
      activity: build(:activity)
    }
  end

  def factory(:season) do
    now = Calendar.DateTime.now_utc

    start_date = now
      |> Calendar.Date.to_erl
      |> Ecto.Date.cast!

    end_date = now
      |> Calendar.Date.advance!(60)
      |> Calendar.Date.to_erl
      |> Ecto.Date.cast!

    %Season{
      vendor_activity: build(:vendor_activity),
      name: sequence(:name, &"season-#{&1}"),
      start_date: start_date,
      end_date: end_date
    }
  end

  def factory(:product) do
    %Product{
      name: sequence(:name, &"product-#{&1}"),
      description: sequence(:description, &"product-description-#{&1}"),
      vendor: build(:vendor),
      experience: build(:experience),
      published: true,
      duration: 100,
      pickup: true
    }
  end

  def build_image(schema) do
    name = sequence(:filename, &"file-#{&1}.jpg")
    build_assoc(schema, :images, [
      filename: name,
      alt: "Caption text for #{name}",
      medium: "priv/images/medium-#{name}",
      original: "priv/images/original-#{name}",
      position: sequence(:position, &(&1))
    ])
  end

  def create_vendor_image(attrs \\ %{}) do
    build(:vendor_image, attrs) |> Repo.insert!
  end

  def create_product_image(attrs \\ %{}) do
    build(:product_image, attrs) |> Repo.insert!
  end

  def create_activity_image(attrs \\ %{}) do
    build(:activity_image, attrs) |> Repo.insert!
  end

  def create_start_time() do
    create_start_time(product: create(:product))
  end

  def create_start_time(params) when is_list(params) do
    Enum.into(params, %{}) |> create_start_time
  end

  def create_start_time(%{season: season, product: product}) do
    StartTime.creation_changeset(%{
      starts_at_time: Ecto.Time.utc(:usec)
    }, product_id: product.id, season_id: season.id)
    |> Repo.insert!
    |> Map.put(:product, product)
    |> Map.put(:season, season)
  end

  def create_start_time(%{season: season}) do
    %{vendor_activity: %{vendor: v, activity: a}}
      = season

    experience = build(:experience)
      |> Map.put(:activity_id, a.id)
      |> Repo.insert!
      |> Map.put(:activity, a.id)
    product = build(:product)
      |> Map.put(:vendor_id, v.id)
      |> Map.put(:experience_id, experience.id)
      |> Repo.insert!
      |> Map.put(:vendor, v)
      |> Map.put(:experience, experience)
    create_start_time %{season: season, product: product}
  end

  def create_start_time(%{product: product}) do
    %{vendor: v, experience: %{activity: a}} = product

    vendor_activity = %VendorActivity{
      vendor_id: v.id, activity_id: a.id
      } |> Repo.insert!

    # give the season the same activity and vendor as product
    season = build(:season)
      |> Map.put(:vendor_activity_id, vendor_activity.id)
      |> Repo.insert!

    create_start_time %{season: season, product: product}
  end

  def create_user_order_for_product() do
    user = create(:user)
    product = create(:product)
    order = create_user_order_for_product(user, product)
    item = order.order_items |> hd

    [
      user: user,
      product: product,
      order: order,
      order_item: item
    ]
  end

  def create_user_order_for_product(user, %Product{} = product) do
    price = create(:price, product: product)
    amount = create(:amount, price: price)
    st = %{season: season}
       = create_start_time(product: product)

    quantity = 3
    cost = amount.amount * quantity

    order_changeset = Order.creation_changeset(%{
      total_amount: cost,
      order_items: [
        %{
          activity_at: Ecto.DateTime.from_date_and_time(season.end_date, st.starts_at_time),
          product_id: product.id,
          amount: cost,
          quantities: %{
            "items" => [
              %{
                  "price_id" => price.id,
                  "sub_total" => cost,
                  "quantity" => quantity,
                  "price_name" => price.name,
                  "price_people_count" => price.people_count
                }
            ]
          }
        }
      ]
    }, user_id: user.id)

    Repo.insert! order_changeset
  end
end
