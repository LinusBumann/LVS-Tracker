defmodule LvsTool.Repo.Migrations.CreateStandardcoursetypes do
  use Ecto.Migration

  def change do
    create table(:standardcoursetypes) do
      add :name, :string, null: false
      add :imputationfactor, :float, null: false
      add :abbreviation, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:standardcoursetypes, [:abbreviation])
    create unique_index(:standardcoursetypes, [:name])
  end
end
