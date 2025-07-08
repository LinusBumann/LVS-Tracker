defmodule LvsTool.Repo.Migrations.CreateSemesters do
  use Ecto.Migration

  def change do
    create table(:semesters) do
      add :name, :string
      add :user_name, :string
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:semesters, [:user_id])
  end
end
