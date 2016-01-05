defmodule Grid.Repo.Migrations.SetProductPublishedTrue do
  use Ecto.Migration
  import Ecto.Query
  
  def up do
    from(p in Grid.Product, update: [set: [published: true]])
    |> Grid.Repo.update_all([])
  end
  def down do
    from(p in Grid.Product, update: [set: [published: nil]])
    |> Grid.Repo.update_all([])
  end
end
