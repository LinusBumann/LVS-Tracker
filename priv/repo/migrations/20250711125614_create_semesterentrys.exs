defmodule LvsTool.Repo.Migrations.CreateSemesterentrys do
  use Ecto.Migration

  def change do
    create table(:semesterentrys) do
      add :name, :string, null: false
      add :status, :string, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:semesterentrys, [:user_id])
  end
end
