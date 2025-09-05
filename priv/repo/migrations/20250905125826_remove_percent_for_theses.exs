defmodule LvsTool.Repo.Migrations.RemovePercentForTheses do
  use Ecto.Migration

  def change do
    alter table(:theses_entries) do
      remove :percent
    end
  end
end
