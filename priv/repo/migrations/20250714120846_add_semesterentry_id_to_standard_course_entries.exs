defmodule LvsTool.Repo.Migrations.AddSemesterentryIdToStandardCourseEntries do
  use Ecto.Migration

  def change do
    alter table(:standard_course_entries) do
      add :semesterentry_id, references(:semesterentrys, on_delete: :nothing)
    end

    create index(:standard_course_entries, [:semesterentry_id])
  end
end
