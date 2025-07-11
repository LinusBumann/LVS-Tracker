defmodule LvsTool.Repo.Migrations.CreateStandardcoursenames do
  use Ecto.Migration

  def change do
    create table(:standardcoursenames) do
      add :name, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:standardcoursenames, [:name])
  end
end
