defmodule Grid.ActivityCategory do
  use Grid.Web, :model

  schema "activity_categories" do
    belongs_to :activity, Grid.Activity
    belongs_to :category, Grid.Category

    timestamps
  end

  @required_fields ~w(activity_id category_id)
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
