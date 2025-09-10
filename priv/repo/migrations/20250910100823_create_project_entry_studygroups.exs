defmodule LvsTool.Repo.Migrations.CreateProjectEntryStudygroups do
  use Ecto.Migration

  def change do
    create table(:project_entry_studygroups) do
      add :project_entry_id, references(:project_entries, on_delete: :delete_all), null: false
      add :studygroup_id, references(:studygroups, on_delete: :delete_all), null: false
    end

    create unique_index(:project_entry_studygroups, [:project_entry_id, :studygroup_id])
  end
end
