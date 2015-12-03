defmodule Grid.Vendor do
  use Grid.Web, :model

  schema "vendors" do
    field :name, :string
    field :description, :string

    has_many :vendor_activity_types, Grid.VendorActivityType
    has_many :activity_types, through: [:vendor_activity_types, :activity_type]

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
  end
end
