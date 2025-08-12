defmodule LvsTool.Repo.Migrations.CreateReductionTypes do
  use Ecto.Migration

  def change do
    create table(:reduction_types) do
      add :reduction_reason, :string, null: false
      add :reduction_lvs, :float, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:reduction_types, [:reduction_reason])
  end
end
