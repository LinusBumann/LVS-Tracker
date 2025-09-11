defmodule LvsTool.Repo.Migrations.CreateExcursionEntryStudygroupsJointable do
  use Ecto.Migration

  def change do
    create table(:excursion_entry_studygroups) do
      add :excursion_entry_id, references(:excursion_entries, on_delete: :delete_all), null: false
      add :studygroup_id, references(:studygroups, on_delete: :delete_all), null: false
    end

    create unique_index(:excursion_entry_studygroups, [:excursion_entry_id, :studygroup_id])
  end
end
