defmodule LvsTool.Repo.Migrations.CreateExcursionEntries do
  use Ecto.Migration

  def change do
    create table(:excursion_entries) do
      add :name, :string
      add :lvs, :float
      add :student_count, :integer
      add :daily_max_teaching_units, :integer
      add :imputationfactor, :float
      add :semesterentry_id, references(:semesterentrys, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:excursion_entries, [:semesterentry_id])
  end
end
