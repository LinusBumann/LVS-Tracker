defmodule LvsTool.Repo.Migrations.RemoveTimestampsFromJoinTables do
  use Ecto.Migration

  def change do
    alter table(:course_entry_types) do
      remove :inserted_at
      remove :updated_at
    end

    alter table(:course_entry_studygroups) do
      remove :inserted_at
      remove :updated_at
    end
  end
end
