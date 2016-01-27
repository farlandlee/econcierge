  defmodule Grid.Experience do
  use Grid.Web, :model

  schema "experiences" do
    field :name, :string
    field :description, :string
    field :slug, :string
    
    belongs_to :activity, Grid.Activity
    belongs_to :image, {"activity_images", Grid.Image}

    has_many :experience_categories, Grid.ExperienceCategory
    has_many :categories, through: [:experience_categories, :category]

    has_many :products, Grid.Product

    timestamps
  end

  @required_fields ~w(name description activity_id)
  @optional_fields ~w(image_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name)
    |> foreign_key_constraint(:activity_id)
    |> foreign_key_constraint(:image_id)
    |> slugify
  end
end
