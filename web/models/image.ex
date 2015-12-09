defmodule Grid.Image do
  use Grid.Web, :model

  schema "images" do
    field :filename, :string
    field :alt, :string
    field :original, :string
    field :medium, :string

    timestamps
  end

  @required_fields ~w(filename)
  @optional_fields ~w(original medium alt)


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
