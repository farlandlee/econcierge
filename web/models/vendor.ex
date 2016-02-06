defmodule Grid.Vendor do
  use Grid.Web, :model

  import Ecto.Query

  alias Grid.Image

  schema "vendors" do
    field :name, :string
    field :description, :string
    field :slug, :string

    field :tripadvisor_location_id, :string
    field :tripadvisor_rating, :float
    field :tripadvisor_rating_image_url, :string
    field :tripadvisor_reviews_count, :integer
    field :tripadvisor_should_update, :boolean,
      default: false, virtual: true

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

  defp maybe_mark_for_tripadvisor_update(changeset) do
    case get_change(changeset, :tripadvisor_location_id) do
      nil -> changeset
      _location -> changeset |> put_change(:tripadvisor_should_update, true)
    end
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
    |> validate_length(:description, min: 1)
    |> validate_format(:tripadvisor_location_id, ~r/^[^d]/, message: "Cannot start with the letter d")
    |> foreign_key_constraint(:default_image_id)
    |> maybe_mark_for_tripadvisor_update
    |> cast_slug
  end

  @required_tripadvisor_fields ~w(
    tripadvisor_rating
    tripadvisor_rating_image_url
    tripadvisor_reviews_count
  )
  def tripadvisor_changeset(model, params) do
    model
    |> cast(params, @required_tripadvisor_fields, [])
    |> validate_number(:tripadvisor_rating, less_than_or_equal_to: 5.0, greater_than_or_equal_to: 0.0)
    |> validate_number(:tripadvisor_reviews_count, greater_than_or_equal_to: 0.0)
  end
end
