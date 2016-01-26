defmodule Grid.Image do
  use Grid.Web, :model

  # Images are an abstraction over relationship-specific
  # images, such as `VendorImage` or `ActivityImage`.
  # See the "Polymorphic associations" header on
  # the Ecto.Schema docs for more.
  # https://hexdocs.pm/ecto/Ecto.Schema.html
  schema "images" do
    field :filename, :string
    field :alt, :string
    field :original, :string
    field :medium, :string
    
    field :error, :boolean, default: false

    field :assoc_id, :integer

    timestamps
  end

  @required_fields ~w(filename)
  @optional_fields ~w(original medium alt error)


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
end
