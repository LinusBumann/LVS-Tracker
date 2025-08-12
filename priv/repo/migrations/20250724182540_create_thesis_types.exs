defmodule LvsTool.Repo.Migrations.CreateThesisTypes do
  use Ecto.Migration

  def change do
    create table(:thesis_types) do
      add :name, :string, null: false
      add :imputationfactor, :float, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:thesis_types, [:name])
  end
end
