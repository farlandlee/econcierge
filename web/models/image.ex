defmodule Grid.Image do
  use Grid.Web, :model

  # Images are an abstraction over relationship-specific
  # images, such as `vendor_images` or `activity_images`.
  # See the "Polymorphic associations" header on
  # the Ecto.Schema docs for more.
  # https://hexdocs.pm/ecto/Ecto.Schema.html
  schema "images" do
    field :filename, :string
    field :alt, :string
    field :original, :string
    field :medium, :string
    field :large, :string
    field :thumb, :string

    field :position, :integer

    field :error, :boolean, default: false

    field :assoc_id, :integer

    timestamps
  end

  @creation_fields ~w(assoc_id)
  @required_fields ~w(filename)
  @optional_fields ~w(alt error position)
  @source_fields ~w(original medium large thumb)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:alt, &String.strip/1)
    |> validate_length(:alt, max: 255)
  end

  def source_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, @source_fields, [])
  end

  def creation_changeset(assoc, params = %{"file" => f}) do
    params = Map.put(params, "filename", f.filename)
    Ecto.build_assoc(assoc, :images)
    |> changeset(params)
    |> cast(%{}, @creation_fields, [])
  end

  def dimensions(:large), do: {718, 359}
  def dimensions(:medium), do: {350, 233}
  def dimensions(:thumb), do: {75, 75}
end
