defmodule Grid.User do
  use Grid.Web, :model

  alias Grid.Models.Validations

  schema "users" do
    field :name, :string
    field :email, :string
    field :image, :string
    field :phone, :string
    field :stripe_id, :string

    timestamps
  end

  @required_fields ~w(name email)
  @optional_fields ~w(image phone stripe_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> Validations.validate_email
  end
end
