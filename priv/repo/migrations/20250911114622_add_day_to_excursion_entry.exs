defmodule LvsTool.Repo.Migrations.AddDayToExcursionEntry do
  use Ecto.Migration

  def change do
    alter table(:excursion_entries) do
      add :day_count, :integer, null: false
    end
  end
end
