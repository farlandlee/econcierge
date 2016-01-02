defmodule Grid.Models.Utils do

  import Ecto.Changeset

  def slugify(changeset, opts \\ [from: :name, field: :slug]) do
    field = Keyword.fetch! opts, :field
    from = Keyword.fetch! opts, :from
    {_, value} = fetch_field(changeset, from)

    slug = Slugger.slugify_downcase(value, ?_)

    changeset
    |> put_change(field, slug)
    |> unique_constraint(field)
  end
end
