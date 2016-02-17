alias Grid.Repo

alias Grid.Activity
alias Grid.Amenity
alias Grid.AmenityOption
alias Grid.Amount
alias Grid.Category
alias Grid.Experience
alias Grid.ExperienceCategory
alias Grid.Image
alias Grid.Location
alias Grid.Price
alias Grid.Product
alias Grid.Season
alias Grid.StartTime
alias Grid.User
alias Grid.Vendor
alias Grid.VendorActivity

Repo.insert %User{
  name: "Development User",
  email: "dev@outpostjh.com"
}

for activity <- ["Fly Fishing", "Snowmobiling", "Paragliding"] do
  activity = Activity.changeset(%Activity{}, %{
    name: activity,
    description: "#{activity} is the most fun you can have in JH."
    })
    |> Repo.insert!

  # Categories!
  categories = for cat <- ["Full Day", "Half Day", "Overnight"] do
    Category.creation_changeset(%{
      name: cat,
      description: cat <> " trip"
      }, activity.id)
    |> Repo.insert!
  end

  a = %{name: activity.name <> " Amenity"}
  |> Amenity.creation_changeset(activity.id)
  |> Repo.insert!

  %{name: a.name <> " Option"}
  |> AmenityOption.creation_changeset(a.id)
  |> Repo.insert!

  # Experiences & Experience Categories
  for n <- 1..3 do
    exp = Experience.creation_changeset(%{
      name: "#{activity.name} Experience #{n}",
      description: "A superb #{activity.name} experience."
      }, activity.id)
      |> Repo.insert!
    # Experience Categories
    for cat <- categories do
      Repo.insert! %ExperienceCategory{
        category_id: cat.id,
        experience_id: exp.id
      }
    end
  end

  # Image
  Image.creation_changeset(activity, %{"file" => %{filename: activity.name <> " image"}})
end

# Vendors
vendor_tuples = [
  {"FishCo", "Fishing is wahoo", "Fly Fishing"},
  {"SnowMoCo", "Do you know what the street value of this mountain is?", "Snowmobiling"}
]
for {name, desc, act_name} <- vendor_tuples, activity = Repo.get_by!(Activity, name: act_name) |> Repo.preload([:categories, :experiences]) do
  vendor = %Vendor{}
  |> Vendor.changeset(%{name: name, description: desc})
  |> Repo.insert!


  va = %VendorActivity{
    vendor_id: vendor.id, activity_id: activity.id
  } |> Repo.insert!
  season = Season.creation_changeset(%{
    name: "Peak Season",
    start_date: "2016-06-15",
    end_date: "2016-08-01"
  }, vendor_activity_id: va.id)
  |> Repo.insert!()

  # Products with prices and start times
  for experience <- activity.experiences do
    product = Product.creation_changeset(%{
      experience_id: experience.id,
      name: "#{vendor.name}'s Product for #{experience.name}",
      description: "Buy #{vendor.name}'s #{experience.description}",
      published: true,
      duration: 300
      }, vendor.id)
    |> Repo.insert!

    price = Price.creation_changeset(%{
      name: "Adult",
      description: "Over 18",
      people_count: 1
    }, product.id)
    |> Repo.insert!

    Amount.creation_changeset(%{
      amount: 180.0,
      max_quantity: 0,
      min_quantity: 1
    }, price.id)
    |> Repo.insert!

    StartTime.creation_changeset(%{
      starts_at_time: %Ecto.Time{hour: 8, min: 0, sec: 0}
    }, product_id: product.id, season_id: season.id)
    |> Repo.insert!
  end

  Repo.insert! Location.creation_changeset(%{
    name: "#{vendor.name} Location",
    address1: "125 E Broadway",
    city: "Jackson",
    state: "WY",
    zip: "83001"
  }, vendor.id)

  # Image
  Image.creation_changeset(vendor, %{"file" => %{filename: vendor.name <> " image"}})
end
