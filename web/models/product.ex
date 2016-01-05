defmodule Grid.Product do
  use Grid.Web, :model

  schema "products" do
    field :description, :string
    field :name, :string

    belongs_to :vendor, Grid.Vendor
    belongs_to :activity, Grid.Activity

    has_many :start_times, Grid.StartTime
    has_many :product_activity_categories, Grid.ProductActivityCategory
    has_many :activity_categories, through: [:product_activity_categories, :activity_category]

    timestamps
  end

  @required_fields ~w(description name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:name, &String.strip/1)
    |> update_change(:description, &String.strip/1)
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:description, min: 1, max: 255)
  end
end
