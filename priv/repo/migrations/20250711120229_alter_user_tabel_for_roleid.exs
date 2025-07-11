defmodule LvsTool.Repo.Migrations.AlterUserTabelForRoleid do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role_id, references(:user_roles, on_delete: :delete_all)
      remove :role
    end
  end
end
