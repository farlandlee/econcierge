defmodule Grid.Repo.Migrations.AncestorIdsNotNull do
  use Ecto.Migration

  import Ecto.Query

  @tables [
    {:categories, :activity_id},
    {:experience_categories, [:experience_id, :category_id]},
    {:experiences, :activity_id},
    {:prices, :product_id},
    {:products, [:vendor_id, :experience_id]},
    {:start_times, :product_id},
    {:vendor_activities, [:vendor_id, :activity_id]},
    {:vendor_images, :assoc_id},
    {:activity_images, :assoc_id}
  ]

  def change do
    allow_null = case direction() do
      :up -> false
      :down -> true
    end

    for {t, columns} <- @tables, columns = List.wrap(columns) do
      if direction == :up do
        # Delete bad data
        for column <- columns do
          t
          |> to_string
          |> Ecto.Queryable.to_query
          |> where([m], is_nil(field(m, ^column)))
          |> Grid.Repo.delete_all()
        end
      end

      alter table(t) do
        for column <- columns do
          modify column, :integer, null: allow_null
        end
      end
    end
  end
end
