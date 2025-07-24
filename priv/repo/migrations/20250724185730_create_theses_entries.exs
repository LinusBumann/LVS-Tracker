defmodule LvsTool.Repo.Migrations.CreateThesesEntries do
  use Ecto.Migration

  def change do
    create table(:theses_entries) do
      add :percent, :float
      add :lvs, :float

      add :studygroup_id, references(:studygroups, on_delete: :nilify_all)
      add :semesterentry_id, references(:semesterentrys, on_delete: :nilify_all)
      add :thesistype_id, references(:thesis_types, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end
  end
end
