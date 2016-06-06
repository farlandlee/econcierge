defmodule Grid.Repo.Migrations.CreateKioskSlide do
  use Ecto.Migration

  def up do
    create table(:kiosk_slides) do
      add :kiosk_id, references(:kiosks, on_delete: :delete_all)
      add :slide_id, references(:slides, on_delete: :delete_all)

      timestamps
    end
    create index(:kiosk_slides, [:kiosk_id])
    create index(:kiosk_slides, [:slide_id])

    execute """
      INSERT INTO kiosk_slides (slide_id, kiosk_id, inserted_at, updated_at)
      SELECT id, kiosk_id, inserted_at, updated_at
      FROM slides
    """

    alter table(:slides) do
      remove :kiosk_id
    end
  end

  def down do
    create table(:slides) do
      add :kiosk_id, references(:kiosks, on_delete: :delete_all)
    end

    execute """
      UPDATE slides
      SET slides.kiosk_id = kiosk_slides.kiosk_id
      FROM kiosk_slides
      WHERE slides.id = kiosk_slides.slide_id
    """

    drop table(:kiosk_slides)
  end
end
