defmodule Grid.Factory do
  use ExMachina.Ecto, repo: Grid.Repo

  alias Grid.Category
  alias Grid.Activity
  alias Grid.ActivityCategory
  alias Grid.Vendor
  alias Grid.Product
  alias Grid.ProductActivityCategory

  def factory(:category) do
    %Category{
      name: sequence(:name, &"category-#{&1}"),
      slug: sequence(:slug, &"category-#{&1}")
    }
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
      activity: build(:activity)
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
