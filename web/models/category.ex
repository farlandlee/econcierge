defmodule Grid.Category do
  use Grid.Web, :model

  schema "categories" do
    field :name, :string
    field :description, :string
    field :slug, :string

    belongs_to :activity, Grid.Activity

    has_many :experience_categories, Grid.ExperienceCategory
    has_many :experiences, through: [:experience_categories, :experience]

    has_many :products, through: [:experiences, :products]

    timestamps
  end

  @required_fields ~w(name description activity_id)
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
    |> unique_constraint(:name, name: :category_name_activity_id_index)
    |> slugify
  end
end
