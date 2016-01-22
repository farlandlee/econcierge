defmodule Grid.Repo.Migrations.SetNumberOfPeople do
  use Ecto.Migration

  import Ecto.Query

  defmodule Price do
    use Grid.Web, :model

    schema "prices" do
      field :people_count, :integer

      Ecto.Schema.timestamps
    end
  end


  def up do
    from(p in Price,
      where: is_nil(p.people_count),
      update: [set: [people_count: 0]])
    |> Grid.Repo.update_all([])
  end

  def down do
    update(Price, set: [people_count: nil])
    |> Grid.Repo.update_all([])
  end
end
