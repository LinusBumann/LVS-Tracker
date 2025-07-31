defmodule LvsTool.Repo.Migrations.AlterReductionTypesTable do
  use Ecto.Migration

  def change do
    alter table(:reduction_types) do
      modify :reduction_lvs, :float, null: true
    end
  end
end
