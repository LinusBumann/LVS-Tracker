defmodule LvsTool.Repo.Migrations.CreateReductionEntries do
  use Ecto.Migration

  def change do
    create table(:reduction_entries) do
      add :lvs, :float
      add :semesterentry_id, references(:semesterentrys, on_delete: :delete_all), null: false
      add :reduction_type_id, references(:reduction_types, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:reduction_entries, [:semesterentry_id])
    create index(:reduction_entries, [:reduction_type_id])
  end
end
