defmodule LvsTool.Repo.Migrations.CreateCourseEntryStudygroups do
  use Ecto.Migration

  def change do
    create table(:course_entry_studygroups) do
      add :standard_course_entry_id, references(:standard_course_entries), null: false
      add :studygroup_id, references(:studygroups), null: false

      timestamps()
    end

    create unique_index(:course_entry_studygroups, [:standard_course_entry_id, :studygroup_id])
  end
end
