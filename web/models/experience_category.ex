defmodule Grid.ExperienceCategory do
  use Grid.Web, :model

  schema "experience_categories" do
    belongs_to :experience, Grid.Experience
    belongs_to :category, Grid.Category

    timestamps
  end

  @required_fields ~w(experience_id category_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:experience_id)
    |> foreign_key_constraint(:category_id)
  end
end
