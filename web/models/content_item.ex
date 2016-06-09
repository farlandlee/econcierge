defmodule Grid.ContentItem do
  use Grid.Web, :model

  schema "content_items" do
    field :context, :string
    field :name, :string
    field :content, :string

    timestamps
  end

  @creation_fields ~w(context name)
  @required_fields ~w(content)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
  end

  def creation_changeset(context, name, content) do
    %__MODULE__{}
    |> changeset(%{content: content})
    |> cast(%{context: context, name: name}, @creation_fields, [])
  end
end
