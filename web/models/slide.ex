defmodule Grid.Slide do
  use Grid.Web, :model

  alias Grid.Models.Validations

  schema "slides" do
    field :photo_url, :string
    field :action_label, :string
    field :action_link, :string
    field :title, :string
    field :title_label, :string
    belongs_to :kiosk, Grid.Kiosk

    timestamps
  end

  @required_fields ~w(photo_url action_link action_label)
  @optional_fields ~w(title title_label )

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:photo_url, &String.strip/1)
    |> validate_length(:photo_url, max: 255)
    |> Validations.validate_url(:photo_url)
    |> update_change(:action_label, &String.strip/1)
    |> validate_length(:action_label, max: 255)
    |> update_change(:action_link, &String.strip/1)
    |> validate_length(:action_link, max: 255)
    |> Validations.validate_url(:action_link)
    |> update_change(:title, &String.strip/1)
    |> validate_length(:title, max: 255)
    |> update_change(:title_label, &String.strip/1)
    |> validate_length(:title_label, max: 255)
  end

  def creation_changeset(params, kiosk_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{kiosk_id: kiosk_id}, [:kiosk_id], [])
    |> foreign_key_constraint(:kiosk_id)
  end
end
