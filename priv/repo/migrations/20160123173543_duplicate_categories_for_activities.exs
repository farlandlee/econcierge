defmodule Category do
  use Ecto.Schema

  schema "categories" do
    field :name, :string
    field :description, :string
    field :slug, :string

    belongs_to :activity, Activity

    Ecto.Schema.timestamps
  end
end

defmodule ExperienceCategory do
  use Ecto.Schema

  schema "experience_categories" do
    belongs_to :experience, Experience
    belongs_to :category, Category

    Ecto.Schema.timestamps
  end
end

defmodule Experience do
  use Ecto.Schema

  schema "experiences" do
    belongs_to :activity, Activity
    has_many :experience_categories, ExperienceCategory
  end
end

defmodule Activity do
  use Ecto.Schema

  schema "activities" do
    has_many :categories, Category

    has_many :experiences, Experience
    has_many :experience_categories, through: [:experiences, :experience_categories]
  end
end

defmodule Grid.Repo.Migrations.DuplicateCategoriesForActivities do
  use Ecto.Migration

  import Ecto.Query

  alias Grid.Repo

  def up do
    for activity <- Repo.all(Activity) |> Repo.preload([experience_categories: [:experience, :category]]) do
      for exp_cat <- activity.experience_categories, cat = exp_cat.category, exp = exp_cat.experience do
        new_cat = %Category{
          name: cat.name,
          description: cat.description,
          slug: "#{cat.slug}-#{exp_cat.id}", #unique-ify slugs
          activity_id: activity.id
        }
        new_cat = Repo.insert! new_cat

        new_exp_cat = %ExperienceCategory{
          category_id: new_cat.id,
          experience_id: exp.id
        }
        Repo.insert! new_exp_cat

        Repo.delete! exp_cat
      end
    end
    # delete the old categories
    from(c in Category, where: is_nil(c.activity_id))
    |> Repo.delete_all
  end
  def down do
    # need to go through and "unique-ify" all of the categories with
    Category
    |> Repo.all()
    |> Enum.group_by(&({&1.name, &1.description}))
    |> Enum.each(fn {{name, description}, categories} ->
      [slug | _] = hd(categories).slug |> String.split("-")
      authoritative_category = Repo.insert! %Category{
        activity_id: nil,
        name: name,
        description: description
      }
      for category <- categories do
        exp_cats = where(ExperienceCategory, [ec], ec.category_id == ^category.id) |> Repo.all
        for exp_cat <- exp_cats do
          exp_cat
          |> Ecto.Changeset.change(category_id: authoritative_category.id)
          |> Repo.update!
        end
        Repo.delete! category
      end
      # Have to do this after we delete the category that had the slug due to unique constraints
      authoritative_category
      |> Ecto.Changeset.change(slug: slug)
      |> Repo.update!
    end)
    # experience categories to point at the new authoritative category
  end
end
