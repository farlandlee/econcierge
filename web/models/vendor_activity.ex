defmodule Grid.VendorActivity do
  use Grid.Web, :model

  schema "vendor_activities" do
    belongs_to :vendor, Grid.Vendor
    belongs_to :activity, Grid.Activity

    has_many :seasons, Grid.Season

    timestamps
  end

  @creation_fields ~w(vendor_id)
  @required_fields ~w(activity_id)
  @optional_fields ~w()

  def creation_changeset(params, vendor_id) do
    %__MODULE__{}
    |> cast(params, @required_fields, @optional_fields)
    |> cast(%{vendor_id: vendor_id}, @creation_fields, [])
    |> foreign_key_constraint(:vendor_id)
    |> foreign_key_constraint(:activity_id)
  end
end
