defmodule LvsTool.Repo.Migrations.AddDescriptionToReductionTypesTable do
  use Ecto.Migration

  def change do
    alter table(:reduction_types) do
      add :description, :text, null: true
    end
  end
end
