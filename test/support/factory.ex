defmodule Grid.Factory do
  use ExMachina.Ecto, repo: Grid.Repo

  import Ecto

  alias Grid.Activity
  alias Grid.Category
  alias Grid.Experience
  alias Grid.ExperienceCategory
  alias Grid.Price
  alias Grid.Product
  alias Grid.StartTime
  alias Grid.Vendor
  alias Grid.VendorActivity

  def factory(:price) do
    %Price{
      product: build(:product),
      name: sequence(:name, &"price-#{&1}"),
      description: sequence(:description, &"Too much moneys by: #{&1}"),
      amount: (:random.uniform() * 1000) |> Float.floor(2)
    }
  end

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

  def factory(:activity_image) do
    name = sequence(:filename, &"file-#{&1}.jpg")
    build_assoc(%Activity{}, :images, [
      filename: name,
      alt: "Caption text for #{name}",
      medium: "priv/images/medium-#{name}",
      original: "priv/images/original-#{name}"
    ])
  end

  def factory(:vendor) do
    %Vendor{
      name: sequence(:name, &"vendor-#{&1}"),
      slug: sequence(:slug, &"vendor-#{&1}"),
      description: "The best!"
    }
  end

  def factory(:vendor_activity) do
    %VendorActivity{
      vendor: build(:vendor),
      activity: build(:activity)
    }
  end

  def factory(:product) do
    %Product{
      name: sequence(:name, &"product-#{&1}"),
      description: sequence(:description, &"product-description-#{&1}"),
      vendor: build(:vendor),
      experience: build(:experience),
      published: true
    }
  end

  def create_vendor_image(attrs \\ %{}) do
    build(:vendor_image, attrs) |> Grid.Repo.insert!
  end

  def create_activity_image(attrs \\ %{}) do
    build(:activity_image, attrs) |> Grid.Repo.insert!
  end
end
