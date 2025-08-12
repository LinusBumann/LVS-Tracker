defmodule LvsTool.Repo.Migrations.RemoveTimestampsFromThesisEntryStudygroups do
  use Ecto.Migration

  def change do
    alter table(:thesis_entry_studygroups) do
      remove :inserted_at
      remove :updated_at
    end
  end
end
