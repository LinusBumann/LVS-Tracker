defmodule LvsTool.Repo.Migrations.CreateCourseEntryTypes do
  use Ecto.Migration

  def change do
    create table(:course_entry_types) do
      add :standard_course_entry_id, references(:standard_course_entries), null: false
      add :standard_course_type_id, references(:standardcoursetypes), null: false

      timestamps()
    end

    create unique_index(:course_entry_types, [:standard_course_entry_id, :standard_course_type_id])
  end
end
