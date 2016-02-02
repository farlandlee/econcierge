defmodule Grid.Amenity do
  use Grid.Web, :model

  schema "amenities" do
    field :name, :string
    belongs_to :activity, Grid.Activity

    has_many :amenity_options, Grid.AmenityOption

    timestamps
  end

  @required_fields ~w(name)
  @creation_fields ~w(activity_id)
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

  def creation_changeset(params, activity_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{activity_id: activity_id}, @creation_fields, [])
    |> foreign_key_constraint(:activity_id)
  end
end
