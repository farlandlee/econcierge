defmodule Grid.Models.Utils do

  import Ecto.Changeset

  def slugify(changeset, opts \\ []) do
    field = Keyword.get opts, :field, :slug
    from = Keyword.get opts, :from, :name
    constraint_name = Keyword.get opts, :constraint_name, nil

    {_, value} = fetch_field(changeset, from)

    slug = Slugger.slugify_downcase(value, ?_)

    changeset
    |> put_change(field, slug)
    |> constraint(field, constraint_name)
  end

  defp constraint(changeset, field, nil) do
    unique_constraint(changeset, field)
  end

  defp constraint(changeset, field, constraint_name) do
    unique_constraint(changeset, field, name: constraint_name)
  end
end
