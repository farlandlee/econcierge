# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Grid.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Grid.Repo

alias Grid.Activity
alias Grid.ActivityCategory
alias Grid.Category
alias Grid.Product
alias Grid.ProductActivityCategory
alias Grid.Vendor
alias Grid.VendorActivity

# only insert if the model doesn't exist unchanged from seeds
insert! = fn model ->
  module = model.__struct__
  fields = module.__schema__(:fields)
  attribs = Map.take(model, fields)
  |> Enum.filter(fn
    {_, nil} -> false
    _ -> true
  end)
  case Repo.get_by(module, attribs) do
    nil -> Repo.insert!(model)
    model -> model
  end
end

# Activities!
[fishing, snowmobiling | _] = ["Fly Fishing", "Snowmobiling", "Paragliding"]
|> Enum.map(fn activity ->
  insert!.(%Activity{
    name: activity,
    description: "#{activity} is the most fun you can have in JH."
  })
end)

#Fishing vendors
vendors = [
  {"Jackson Hole Anglers", "Fishing is wahoo"},
  {"Some Fishing Company", "Yay for fishing"},
  {"Boats and Rods", "All the fish."},
  {"Casting Flys", "Meow meow meow."}
]
|> Enum.map(fn {name, description} ->
  insert!.(%Vendor{name: name, description: description})
end)
# hook them up to the fishing activity
vendors |> Enum.each(fn v ->
  insert!.(%VendorActivity{vendor_id: v.id, activity_id: fishing.id})
end)

#Productiones
fishing_prod = insert!.(%Product{
  name: "All the product",
  description: "Buy it!",
  vendor_id: hd(vendors).id,
  activity_id: fishing.id
})
snowmo_prod = insert!.(%Product{
  name: "Snowmobiling product",
  description: "Buy it!",
  vendor_id: Enum.at(vendors, 2).id,
  activity_id: snowmobiling.id
})

# add categories for fly fishing
["Half Day", "Full Day", "Overnight", "Classes"]
|> Enum.map(&(insert!.(%Category{name: &1})))
|> Enum.map(fn category ->
  ac = insert!.(%ActivityCategory{
    activity_id: fishing.id,
    category_id: category.id
  })
  insert!.(%ProductActivityCategory{
    activity_category_id: ac.id,
    product_id: fishing_prod.id
  })

  ac = insert!.(%ActivityCategory{
    activity_id: snowmobiling.id,
    category_id: category.id
  })
  insert!.(%ProductActivityCategory{
    activity_category_id: ac.id,
    product_id: snowmo_prod.id
  })
end)

for m <- [Activity, Category, Product, Vendor] do
  Enum.map(Repo.all(m), fn model ->
    model
    |> Ecto.Changeset.change
    |> Grid.Models.Utils.slugify
    |> Repo.update!
  end)
end
