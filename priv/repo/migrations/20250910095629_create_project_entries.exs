defmodule LvsTool.Repo.Migrations.CreateProjectEntries do
  use Ecto.Migration

  def change do
    create table(:project_entries) do
      add :name, :string
      add :kind, :string
      add :sws, :float
      add :student_count, :integer
      add :percent, :float
      add :lvs, :float
      add :semesterentry_id, references(:semesterentrys, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:project_entries, [:semesterentry_id])
  end
end
