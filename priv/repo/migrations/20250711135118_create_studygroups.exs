defmodule LvsTool.Repo.Migrations.CreateStudygroups do
  use Ecto.Migration

  def change do
    create table(:studygroups) do
      add :name, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:studygroups, [:name])
  end
end
