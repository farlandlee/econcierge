defmodule Grid.Category do
  use Grid.Web, :model

  schema "categories" do
    field :name, :string
    field :description, :string
    field :slug, :string

    belongs_to :activity, Grid.Activity
    belongs_to :image, {"activity_images", Grid.Image}

    has_many :experience_categories, Grid.ExperienceCategory
    has_many :experiences, through: [:experience_categories, :experience]
    belongs_to :default_experience, Grid.Experience

    has_many :products, through: [:experiences, :products]

    timestamps
  end

  def by_activity(query \\ __MODULE__, activity_id)
  def by_activity(query, nil), do: query
  def by_activity(query, activity_id) do
    from c in query, where: c.activity_id == ^activity_id
  end

  @creation_fields ~w(activity_id)
  @required_fields ~w(name description)
  @optional_fields ~w(image_id slug default_experience_id)

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
    |> unique_constraint(:name, name: :categories_name_activity_id_index)
    |> validate_length(:description, min: 1)
    |> foreign_key_constraint(:image_id)
    |> cast_slug(constraint_options: [name: :categories_slug_activity_id_index])
  end

  def creation_changeset(params, activity_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{activity_id: activity_id}, @creation_fields, [])
    |> foreign_key_constraint(:activity_id)
  end

  def having_published_products(query \\ __MODULE__) do
    from a in query,
      join: p in assoc(a, :products),
      where: p.published == true,
      distinct: true
  end
end
