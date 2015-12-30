defmodule Grid.ProductActivityCategory do
  use Grid.Web, :model

  schema "product_activity_categories" do
    belongs_to :activity_category, Grid.ActivityCategory
    belongs_to :product, Grid.Product

    timestamps
  end

  @required_fields ~w(activity_category_id product_id)
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
