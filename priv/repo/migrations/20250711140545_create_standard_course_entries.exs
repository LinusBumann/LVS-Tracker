defmodule LvsTool.Repo.Migrations.CreateStandardCourseEntries do
  use Ecto.Migration

  def change do
    create table(:standard_course_entries) do
      add :kind, :string
      add :sws, :float
      add :student_count, :integer
      add :percent, :float
      add :lvs, :float
      add :standardcoursetype_id, references(:standardcoursetypes, on_delete: :nothing)
      add :standardcoursename_id, references(:standardcoursenames, on_delete: :nothing)
      add :studygroup_id, references(:studygroups, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:standard_course_entries, [:standardcoursetype_id])
    create index(:standard_course_entries, [:standardcoursename_id])
    create index(:standard_course_entries, [:studygroup_id])
  end
end
