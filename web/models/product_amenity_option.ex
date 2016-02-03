defmodule Grid.ProductAmenityOption do
  use Grid.Web, :model

  schema "product_amenity_options" do
    belongs_to :product, Grid.Product
    belongs_to :amenity_option, Grid.AmenityOption

    timestamps
  end

  @required_fields ~w(product_id amenity_option_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:amenity_option_id)
  end
end
