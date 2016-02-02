defmodule Season do
  use Grid.Web, :model

  schema "seasons" do
    belongs_to :vendor_activity, VendorActivity
  end
end

defmodule Experience do
  use Grid.Web, :model
  schema "experiences" do
    field :activity_id, :integer
  end
end

defmodule Product do
  use Grid.Web, :model
  schema "products" do
    field :vendor_id, :integer
    belongs_to :experience, Experience
  end
end

defmodule Vendor do
  use Grid.Web, :model
  schema "vendors" do end
end

defmodule VendorActivity do
  use Grid.Web, :model

  schema "vendor_activities" do
    field :vendor_id, :integer
    field :activity_id, :integer
    has_many :seasons, Season
  end
end

defmodule StartTime do
  use Grid.Web, :model

  schema "start_times" do
    belongs_to :product, Product
    field :season_id, :integer

    timestamps
  end
end

defmodule Grid.Repo.Migrations.PopulateStartTimeSeason do
  use Ecto.Migration

  alias Grid.Repo

  def up do
    # migrate nil values to the only existing VAS.
    # Obviously, this only works if run immediately after the changeset
    # that created Season. If there's more than one season for that
    # vendor activity combo, stuff is gon' break.
    for start_time <- Repo.all(StartTime) |> Repo.preload(product: :experience) do
      vendor_id = start_time.product.vendor_id
      activity_id = start_time.product.experience.activity_id
      vas = Repo.get_by!(VendorActivity,
        vendor_id: vendor_id,
        activity_id: activity_id
      ) |> Repo.preload(:seasons)

      start_time
      |> Ecto.Changeset.change(season_id: hd(vas.seasons).id)
      |> Repo.update!
    end
    # and now enforce not null
    alter table(:start_times) do
      modify :season_id, :integer, null: false
    end
  end

  def down do
    alter table(:start_times) do
      modify :season_id, :integer, null: true
    end
  end
end
