defmodule LvsTool.Repo.Migrations.RemoveStudygroupidFromThesesEntries do
  use Ecto.Migration

  def change do
    alter table(:theses_entries) do
      remove :studygroup_id
    end
  end
end
