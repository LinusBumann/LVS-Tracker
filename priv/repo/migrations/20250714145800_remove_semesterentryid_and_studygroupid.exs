defmodule LvsTool.Repo.Migrations.RemoveSemesterentryidAndStudygroupid do
  use Ecto.Migration

  def change do
    alter table(:standard_course_entries) do
      remove :standardcoursetype_id
      remove :studygroup_id
    end
  end
end
