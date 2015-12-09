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
import Grid.Repo, only: [insert!: 1]
alias Grid.Activity
alias Grid.Vendor
alias Grid.VendorActivity

for activity <- ~w(Snowmobiling Paragliding) do
  insert!(%Activity{name: activity, description: "#{activity} is the most fun you can have in JH."})
end

a = insert!(%Activity{name: "Fly Fishing", description: "Water sports are good times."})

v = insert!(%Vendor{name: "Jackson Hole Anglers", description: "The best in fishin'"})

insert!(%VendorActivity{vendor_id: v.id, activity_id: a.id})
