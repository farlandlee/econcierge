defmodule Grid.Factory do
  use ExMachina.Ecto, repo: Grid.Repo

  import Ecto

  alias Grid.Activity
  alias Grid.ActivityCategory
  alias Grid.Category
  alias Grid.Product
  alias Grid.ProductActivityCategory
  alias Grid.StartTime
  alias Grid.Vendor

  def factory(:start_time) do
    %StartTime{
      product: build(:product),
      starts_at_time: Ecto.Time.utc(:usec)
    }
  end

  def factory(:category) do
    %Category{
      name: sequence(:name, &"category-#{&1}"),
      slug: sequence(:slug, &"category-#{&1}")
    }
  end

  def factory(:vendor_image) do
    name = sequence(:filename, &"file-#{&1}.jpg")
    build_assoc(%Vendor{}, :images, [
      filename: name,
      alt: "Caption text for #{name}",
      medium: "priv/images/medium-#{name}",
      original: "priv/images/original-#{name}"
    ])
  end

  def create_vendor_image(attrs \\ %{}) do
    build(:vendor_image, attrs) |> Grid.Repo.insert!
  end

  def factory(:activity) do
    %Activity{
      name: sequence(:name, &"activity-#{&1}"),
      description: "Something fun!",
      slug: sequence(:slug, &"activity-#{&1}")
    }
  end

  def factory(:activity_category) do
    %ActivityCategory{
      activity: build(:activity),
      category: build(:category)
    }
  end

  def factory(:vendor) do
    %Vendor{
      name: sequence(:name, &"vendor-#{&1}"),
      slug: sequence(:slug, &"vendor-#{&1}"),
      description: "The best!"
    }
  end

  def factory(:product) do
    %Product{
      name: sequence(:name, &"product-#{&1}"),
      description: "Buy it!",
      vendor: build(:vendor),
      activity: build(:activity),
      published: true
    }
  end

  def factory(:product_activity_category) do
    %ProductActivityCategory{
      product: build(:product),
      activity_category: build(:activity_category)
    }
  end

  def with_activity_category(%Product{} = product) do
    create(
      :product_activity_category,
      product: product,
      activity_category: build(:activity_category, activity: product.activity)
    )

    product
  end
end
