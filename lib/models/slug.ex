defmodule Grid.Models.Slug do

  import Ecto.Changeset

  def cast_slug(changeset, opts \\ []) do
    slug_field         = Keyword.get opts, :as, :slug
    source_field       = Keyword.get opts, :from, :name
    constraint_options = Keyword.get opts, :constraint_options, []

    fetched_slug   = fetch_field(changeset, slug_field)
    fetched_source = fetch_field(changeset, source_field)

    case generate_slug(fetched_slug, fetched_source) do
      :no_change -> changeset
      slug ->
        changeset
        |> put_change(slug_field, slug)
        |> unique_constraint(slug_field, constraint_options)
    end
  end

  defp generate_slug(fetched_slug, fetched_source)

  defp generate_slug({_, nil}, {_, source_value}) do
    slugify(source_value)
  end
  # User set slug, just need to enforce no spaces etc
  defp generate_slug({:changes, changed_slug}, _) do
    slugify(changed_slug)
  end

  defp generate_slug(_, _) do
    :no_change
  end

  defp slugify(value) do
    Slugger.slugify_downcase(value, ?_)
  end
end
