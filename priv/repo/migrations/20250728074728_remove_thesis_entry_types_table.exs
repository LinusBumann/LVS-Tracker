defmodule LvsTool.Repo.Migrations.RemoveThesisEntryTypesTable do
  use Ecto.Migration

  def change do
    drop table(:thesis_entry_types)
  end
end
