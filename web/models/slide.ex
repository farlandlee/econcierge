defmodule Grid.Slide do
  use Grid.Web, :model

  schema "slides" do
    field :name, :string
    field :photo_url, :string
    field :action_label, :string
    field :action_link, :string
    field :title, :string
    field :title_label, :string

    timestamps
  end

  @required_fields ~w(name photo_url action_link action_label)
  @optional_fields ~w(title title_label)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:name, &String.strip/1)
    |> validate_length(:name, max: 255)
    |> update_change(:photo_url, &String.strip/1)
    |> validate_length(:photo_url, max: 255)
    |> update_change(:action_label, &String.strip/1)
    |> validate_length(:action_label, max: 255)
    |> update_change(:action_link, &String.strip/1)
    |> validate_length(:action_link, max: 255)
    |> update_change(:title, &String.strip/1)
    |> validate_length(:title, max: 255)
    |> update_change(:title_label, &String.strip/1)
    |> validate_length(:title_label, max: 255)
  end
end
