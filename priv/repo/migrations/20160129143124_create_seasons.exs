defmodule VendorActivity do
  use Grid.Web, :model

  schema "vendor_activities" do
    field :vendor_id, :integer
    field :activity_id, :integer
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

defmodule Grid.Repo.Migrations.CreateSeason do
  use Ecto.Migration

  def change do
    create table(:seasons) do
      add :name,       :string, null: :false

      add :start_date_day, :integer, null: :false
      add :start_date_month, :integer, null: :false
      add :end_date_day, :integer, null: :false
      add :end_date_month, :integer, null: :false

      add :vendor_activity_id, references(:vendor_activities, on_delete: :delete_all), null: :false

      timestamps
    end

    create index(:seasons, [:vendor_activity_id])

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
