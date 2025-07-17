defmodule LvsTool.Repo.Migrations.AddCascadeDeleteForJoinTables do
  use Ecto.Migration

  def change do
    # 1. Entferne die bestehenden Foreign Key Constraints aus course_entry_studygroups
    drop constraint(
           :course_entry_studygroups,
           "course_entry_studygroups_standard_course_entry_id_fkey"
         )

    drop constraint(:course_entry_studygroups, "course_entry_studygroups_studygroup_id_fkey")

    # 2. Entferne die bestehenden Foreign Key Constraints aus course_entry_types
    drop constraint(:course_entry_types, "course_entry_types_standard_course_entry_id_fkey")
    drop constraint(:course_entry_types, "course_entry_types_standardcoursetype_id_fkey")

    # 3. Entferne den Foreign Key Constraint aus standard_course_entries für semesterentry_id
    drop constraint(:standard_course_entries, "standard_course_entries_semesterentry_id_fkey")

    # 4. Füge die Foreign Key Constraints mit CASCADE DELETE wieder hinzu

    # course_entry_studygroups - wenn standard_course_entry gelöscht wird, lösche auch die Verknüpfung
    alter table(:course_entry_studygroups) do
      modify :standard_course_entry_id,
             references(:standard_course_entries, on_delete: :delete_all),
             null: false

      modify :studygroup_id, references(:studygroups, on_delete: :delete_all), null: false
    end

    # course_entry_types - wenn standard_course_entry gelöscht wird, lösche auch die Verknüpfung
    alter table(:course_entry_types) do
      modify :standard_course_entry_id,
             references(:standard_course_entries, on_delete: :delete_all),
             null: false

      modify :standardcoursetype_id, references(:standardcoursetypes, on_delete: :delete_all),
        null: false
    end

    # standard_course_entries - wenn semesterentry gelöscht wird, lösche auch alle standard_course_entries
    alter table(:standard_course_entries) do
      modify :semesterentry_id, references(:semesterentrys, on_delete: :delete_all), null: false
    end
  end
end
