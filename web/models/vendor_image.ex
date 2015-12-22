defmodule Grid.VendorImage do
  use Grid.Web, :model

  schema "vendor_images" do
    belongs_to :vendor, Grid.Vendor
    belongs_to :image, Grid.Image

    timestamps
  end

  @required_fields ~w(vendor image)
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
