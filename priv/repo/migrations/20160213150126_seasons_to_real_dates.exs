defmodule Grid.Repo.Migrations.SeasonsToRealDates do
  use Ecto.Migration

  def up do
    alter table(:seasons) do
      add :start_date, :date
      add :end_date, :date
    end

    {year, _, _} = :erlang.date()
    execute """
      UPDATE seasons SET
        start_date=to_date('#{year}' || '-' || start_date_month || '-' || start_date_day, 'YYYY-MM-DD'),
        end_date=to_date('#{year}' || '-' || end_date_month || '-' || end_date_day, 'YYYY-MM-DD')
    """

    alter table(:seasons) do
      modify :start_date, :date, null: false
      modify :end_date, :date, null: false
      remove :start_date_month
      remove :start_date_day
      remove :end_date_month
      remove :end_date_day
    end
  end

  def down do
    alter table(:seasons) do
      add :start_date_day, :integer
      add :start_date_month, :integer
      add :end_date_day, :integer
      add :end_date_month, :integer
    end

    execute """
      UPDATE seasons SET
        start_date_month=extract(month from start_date),
        start_date_day=extract(day from start_date),
        end_date_month=extract(month from end_date),
        end_date_day=extract(day from end_date)
    """

    alter table(:seasons) do
      modify :start_date_day, :integer, null: false
      modify :start_date_month, :integer, null: false
      modify :end_date_day, :integer, null: false
      modify :end_date_month, :integer, null: false
      remove :start_date
      remove :end_date
    end
  end
end
