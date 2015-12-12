defmodule Grid.Activity do
  use Grid.Web, :model

  schema "activities" do
    field :name, :string
    field :description, :string

    has_many :vendor_activities, Grid.VendorActivity
    has_many :vendors, through: [:vendor_activities, :vendor]

    timestamps
  end

  @required_fields ~w(name description)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 1, max: 255)
    |> unique_constraint(:name)
  end
end
