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
alias Grid.Vendor
alias Grid.VendorActivity
alias Grid.Category
alias Grid.ActivityCategory

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
~w(Snowmobiling Paragliding)
|> Enum.map(fn activity ->
  insert!.(%Activity{
    name: activity,
    description: "#{activity} is the most fun you can have in JH."
  })
end)

fishing = insert!.(%Activity{
  name: "Fly Fishing", description: "Water sports are good times."
})

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

# add categories for fly fishing
["Half Day", "Full Day", "Overnight", "Classes"]
|> Enum.map(&(insert!.(%Category{name: &1})))
|> Enum.each(fn category ->
  insert!.(%ActivityCategory{
    activity_id: fishing.id,
    category_id: category.id
  })
end)
