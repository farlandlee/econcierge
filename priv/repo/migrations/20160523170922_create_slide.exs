defmodule Grid.Repo.Migrations.CreateSlide do
  use Ecto.Migration

  def change do
    create table(:slides) do
      add :photo_url, :string, null: false
      add :action_label, :string, null: false
      add :action_link, :string, null: false
      add :kiosk_id, references(:kiosks, on_delete: :delete_all), null: false
      add :title, :string
      add :title_label, :string

      timestamps
    end
    create index(:slides, [:kiosk_id])
  end
end
