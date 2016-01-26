defmodule Grid.Repo.Migrations.FixExpCatCategoryFk do
  use Ecto.Migration

  def up do
    execute """
      ALTER TABLE experience_categories
        DROP CONSTRAINT experience_categories_category_id_fkey,
        ADD CONSTRAINT experience_categories_category_id_fkey FOREIGN KEY (category_id)
          REFERENCES categories(id) ON DELETE CASCADE;
    """
  end

  def down do
    execute """
      ALTER TABLE experience_categories
        DROP CONSTRAINT experience_categories_category_id_fkey,
        ADD CONSTRAINT experience_categories_category_id_fkey FOREIGN KEY (category_id)
          REFERENCES categories(id) ON DELETE SET NULL;
    """
  end
end
