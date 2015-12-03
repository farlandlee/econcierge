defmodule Grid.VendorActivityType do
  use Grid.Web, :model

  schema "vendor_activity_types" do
    belongs_to :vendor, Grid.Vendor
    belongs_to :activity_type, Grid.ActivityType

    timestamps
  end

  @required_fields ~w(vendor_id activity_type_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
