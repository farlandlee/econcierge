defmodule Category do
  use Ecto.Schema

  schema "categories" do
    field :slug, :string

    Ecto.Schema.timestamps
  end
end

defmodule Grid.Repo.Migrations.DropCategorySlugActivityIdPortion do
  use Ecto.Migration

  def up do
    for category <- Grid.Repo.all(Category) do
      slug = category.slug |> String.split("-") |> hd
      category
      |> Ecto.Changeset.change(slug: slug)
      |> Grid.Repo.update!
    end
  end
  def down do
    #uh oh
  end
end
