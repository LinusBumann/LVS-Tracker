defmodule LvsTool.Repo.Migrations.AddThesisTitleFieldToThesesEntries do
  use Ecto.Migration

  def change do
    alter table(:theses_entries) do
      add :thesis_title, :string, null: false
    end
  end
end
