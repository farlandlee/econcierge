alias Grid.Repo

alias Grid.Activity
alias Grid.Category
alias Grid.Product
alias Grid.Vendor
alias Grid.VendorActivity
alias Grid.Experience
alias Grid.ExperienceCategory
alias Grid.Price

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

# Categories!
[full, half | _] = ["Full Day", "Half Day", "Overnight"]
|> Enum.map(fn category ->
  insert!.(%Category{
    name: category,
    description: category
  })
end)

fishing_vendors = [
  {"FishCo", "Fishing is wahoo"}
]
|> Enum.map(fn {name, description} ->
  v = insert!.(%Vendor{name: name, description: description})
  insert!.(%VendorActivity{vendor_id: v.id, activity_id: fishing.id})
  v
end)

snowmobiling_vendors = [
  {"SnowMoCo", "Do you know what the street value of this mountain is?"}
]
|> Enum.map(fn {name, description} ->
  v = insert!.(%Vendor{name: name, description: description})
  insert!.(%VendorActivity{vendor_id: v.id, activity_id: snowmobiling.id})
  v
end)

#Products
fish_exp = insert!.(%Experience{
  name: "Moose to Wilson",
  description: "Good Views",
  activity_id: fishing.id
})
fishing_prod = insert!.(%Product{
  name: "Two Person Float",
  description: "Buy it!",
  vendor_id: hd(fishing_vendors).id,
  experience_id: fish_exp.id,
  published: true
})
insert!.(%ExperienceCategory{
  experience_id: fish_exp.id,
  category_id: half.id
})
insert!.(%Price{
  product_id: fishing_prod.id,
  name: "Adult",
  description: "Over 18",
  amount: 180.0
})

snowmo_exp = insert!.(%Experience{
  name: "Granite Hotsprings",
  description: "Sled & Soak",
  activity_id: snowmobiling.id
})
snowmo_prod = insert!.(%Product{
  name: "Double Sled",
  description: "Buy it!",
  vendor_id: hd(snowmobiling_vendors).id,
  experience_id: snowmo_exp.id,
  published: true
})
insert!.(%ExperienceCategory{
  experience_id: snowmo_exp.id,
  category_id: full.id
})
insert!.(%Price{
  product_id: snowmo_prod.id,
  name: "Adult",
  description: "Over 18",
  amount: 250.0
})

for m <- [Activity, Category, Product, Vendor, Experience] do
  Enum.map(Repo.all(m), fn model ->
    model
    |> Ecto.Changeset.change
    |> Grid.Models.Utils.slugify
    |> Repo.update!
  end)
end
