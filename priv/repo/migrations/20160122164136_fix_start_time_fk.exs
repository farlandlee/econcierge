defmodule Grid.Repo.Migrations.FixStartTimeFk do
  use Ecto.Migration

  def up do
    execute """
      ALTER TABLE start_times
        DROP CONSTRAINT start_times_product_id_fkey,
        ADD CONSTRAINT start_times_product_id_fkey FOREIGN KEY (product_id)
          REFERENCES products(id) ON DELETE CASCADE;
    """
  end

  def down do
    execute """
      ALTER TABLE start_times
        DROP CONSTRAINT start_times_product_id_fkey,
        ADD CONSTRAINT start_times_product_id_fkey FOREIGN KEY (product_id)
          REFERENCES products(id);
    """
  end
end
