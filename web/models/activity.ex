defmodule Grid.Activity do
  use Grid.Web, :model

  alias Grid.Image

  schema "activities" do
    field :name, :string
    field :description, :string
    field :slug, :string

    belongs_to :default_image, {"activity_images", Image}
    has_many :images, {"activity_images", Image}, foreign_key: :assoc_id

    has_many :vendor_activities, Grid.VendorActivity
    has_many :vendors, through: [:vendor_activities, :vendor]

    has_many :amenities, Grid.Amenity
    has_many :categories, Grid.Category
    has_many :experiences, Grid.Experience

    has_many :products, through: [:experiences, :products]

    timestamps
  end

  @required_fields ~w(name description)
  @optional_fields ~w(slug default_image_id)

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
    |> unique_constraint(:name)
    |> foreign_key_constraint(:default_image_id)
    |> cast_slug
  end
end
