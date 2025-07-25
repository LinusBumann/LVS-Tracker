defmodule LvsTool.Repo.Migrations.CreateThesisEntryStdygroups do
  use Ecto.Migration

  def change do
    create table(:thesis_entry_studygroups) do
      add :thesis_entry_id, references(:theses_entries, on_delete: :delete_all), null: false
      add :studygroup_id, references(:studygroups, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:thesis_entry_studygroups, [:thesis_entry_id, :studygroup_id])
  end
end
