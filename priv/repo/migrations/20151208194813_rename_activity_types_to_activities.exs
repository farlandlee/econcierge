defmodule Grid.Repo.Migrations.RenameActivityTypesToActivities do
  use Ecto.Migration

  def up do
    drop index(:vendor_activity_types, [:vendor_id])
    drop index(:vendor_activity_types, [:activity_type_id])
    execute("ALTER TABLE vendor_activity_types DROP CONSTRAINT vendor_activity_types_activity_type_id_fkey")

    rename table(:vendor_activity_types), to: table(:vendor_activities)
    rename table(:vendor_activities), :activity_type_id, to: :activity_id
    execute("ALTER SEQUENCE vendor_activity_types_id_seq RENAME TO vendor_activity_id_seq")

    rename table(:activity_types), to: table(:activities)
    execute("ALTER SEQUENCE activity_types_id_seq RENAME TO activity_id_seq")

    create index(:vendor_activities, [:vendor_id])
    create index(:vendor_activities, [:activity_id])

    alter table(:vendor_activities) do
      modify :activity_id, references(:activities, on_delete: :delete_all)
    end
  end

  def down do
    drop index(:vendor_activities, [:vendor_id])
    drop index(:vendor_activities, [:activity_id])
    execute("ALTER TABLE vendor_activities DROP CONSTRAINT vendor_activities_activity_id_fkey")

    rename table(:vendor_activities), to: table(:vendor_activity_types)
    rename table(:vendor_activity_types), :activity_id, to: :activity_type_id
    execute("ALTER SEQUENCE vendor_activity_id_seq RENAME TO vendor_activity_types_id_seq")

    rename table(:activities), to: table(:activity_types)
    execute("ALTER SEQUENCE activity_id_seq RENAME TO activity_types_id_seq")

    create index(:vendor_activity_types, [:vendor_id])
    create index(:vendor_activity_types, [:activity_type_id])

    alter table(:vendor_activity_types) do
      modify :activity_type_id, references(:activity_types, on_delete: :delete_all)
    end
  end
end
