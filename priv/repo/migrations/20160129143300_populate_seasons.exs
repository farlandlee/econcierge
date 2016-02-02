defmodule VendorActivity do
  use Grid.Web, :model

  schema "vendor_activities" do
  end
end

defmodule Season do
  use Grid.Web, :model

  schema "seasons" do
    field :vendor_activity_id, :integer
    field :name,        :string

    field :start_date_day, :integer
    field :start_date_month, :integer

    field :end_date_day, :integer
    field :end_date_month, :integer

    timestamps
  end
end

defmodule Grid.Repo.Migrations.PopulateSeasons do
  use Ecto.Migration

  def change do
    # Create default "Peak Season" season for each vendor activity
    for %{id: id} <- Grid.Repo.all(VendorActivity) do
      Grid.Repo.insert! %Season{
        name: "Peak Season",
        start_date_month: 6, start_date_day: 15,
        end_date_month: 8, end_date_day: 31,
        vendor_activity_id: id
      }
    end
  end
end
