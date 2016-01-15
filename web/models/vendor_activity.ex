defmodule Grid.VendorActivity do
  use Grid.Web, :model

  schema "vendor_activities" do
    belongs_to :vendor, Grid.Vendor
    belongs_to :activity, Grid.Activity

    timestamps
  end

  @required_fields ~w(vendor_id activity_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:vendor_id)
    |> foreign_key_constraint(:activity_id)
  end
end
