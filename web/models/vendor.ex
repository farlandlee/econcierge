defmodule Grid.Vendor do
  use Grid.Web, :model

  import Ecto.Query

  alias Grid.Image

  schema "vendors" do
    field :name, :string
    field :description, :string
    field :slug, :string

    field :tripadvisor_location_id, :string

    belongs_to :default_image, {"vendor_images", Image}
    has_many :images, {"vendor_images", Image}, foreign_key: :assoc_id

    has_many :locations, Grid.Location

    has_many :products, Grid.Product

    has_many :vendor_activities, Grid.VendorActivity
    has_many :activities, through: [:vendor_activities, :activity]
    has_many :experiences, through: [:vendor_activities, :activity, :experiences]
    has_many :seasons, through: [:vendor_activities, :seasons]

    timestamps
  end

  def with_activity(query \\ __MODULE__, activity_id)
  def with_activity(query, nil) do
    query
  end
  def with_activity(query, id) do
    query
    |> join(:inner, [v], va in assoc(v, :vendor_activities))
    |> join(:inner, [v, va], a in assoc(va, :activity))
    |> where([v, va, a], a.id == ^id)
  end

  @required_fields ~w(name description)
  @optional_fields ~w(slug default_image_id tripadvisor_location_id)

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
    |> foreign_key_constraint(:default_image_id)
    |> cast_slug
  end
end
