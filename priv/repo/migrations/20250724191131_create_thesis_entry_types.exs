defmodule LvsTool.Repo.Migrations.CreateThesisEntryTypes do
  use Ecto.Migration

  def change do
    create table(:thesis_entry_types) do
      add :thesis_entry_id, references(:theses_entries, on_delete: :delete_all), null: false
      add :thesis_type_id, references(:thesis_types, on_delete: :delete_all), null: false
    end

    create unique_index(:thesis_entry_types, [:thesis_entry_id, :thesis_type_id])
  end
end
