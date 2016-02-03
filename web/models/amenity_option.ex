defmodule Grid.AmenityOption do
  use Grid.Web, :model

  schema "amenity_options" do
    field :name, :string
    belongs_to :amenity, Grid.Amenity

    has_many :product_amenity_options, Grid.ProductAmenityOption

    has_one :activity, through: [:amenity, :activity]

    timestamps
  end

  @required_fields ~w(name)
  @creation_fields ~w(amenity_id)
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
    |> validate_length(:name, min: 1, max: 255)
  end

  def creation_changeset(params, amenity_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{amenity_id: amenity_id}, @creation_fields, [])
    |> foreign_key_constraint(:amenity_id)
  end
end
