defmodule Grid.Repo.Migrations.SetProductPublishedTrue do
  use Ecto.Migration
  import Ecto.Query

  defmodule Product do
    use Grid.Web, :model
    schema "products" do
      field :published, :boolean

      Ecto.Schema.timestamps
    end
  end

  def up do
    from(p in Product, update: [set: [published: true]])
    |> Grid.Repo.update_all([])
  end
  def down do
    from(p in Product, update: [set: [published: nil]])
    |> Grid.Repo.update_all([])
  end
end
