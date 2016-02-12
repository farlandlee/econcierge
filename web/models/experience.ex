  defmodule Grid.Experience do
  use Grid.Web, :model

  import Ecto.Query

  alias Grid.Product

  schema "experiences" do
    field :name, :string
    field :description, :string
    field :slug, :string

    belongs_to :activity, Grid.Activity
    belongs_to :image, {"activity_images", Grid.Image}

    has_many :experience_categories, Grid.ExperienceCategory
    has_many :categories, through: [:experience_categories, :category]

    has_many :products, Product

    timestamps
  end

  def for_category(query \\ __MODULE__, category_id)
  def for_category(query, nil), do: query
  def for_category(query, category_id) do
    from e in query,
      join: ec in assoc(e, :experience_categories),
      where: ec.category_id == ^category_id
  end

  def for_activity(query \\ __MODULE__, activity_id)
  def for_activity(query, nil), do: query
  def for_activity(query, activity_id) do
    where(query, [e], e.activity_id == ^activity_id)
  end

  def having_published_products(query \\ __MODULE__, product_ids)
  def having_published_products(query, nil) do
    from e in query,
      join: p in assoc(e, :products),
      where: p.published == true,
      distinct: true
  end
  def having_published_products(query, product_ids) do
    from e in query,
      join: p in assoc(e, :products),
      where: p.id in ^product_ids,
      where: p.published == true,
      distinct: true
  end

  @creation_fields ~w(activity_id)
  @required_fields ~w(name description)
  @optional_fields ~w(image_id slug)

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
    |> validate_length(:description, min: 1)
    |> foreign_key_constraint(:image_id)
    |> cast_slug()
  end

  def creation_changeset(params, activity_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{activity_id: activity_id}, @creation_fields, [])
    |> foreign_key_constraint(:activity_id)
  end
end
