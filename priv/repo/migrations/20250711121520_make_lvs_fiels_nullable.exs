defmodule LvsTool.Repo.Migrations.MakeLvsFielsNullable do
  use Ecto.Migration

  def change do
    alter table(:user_roles) do
      modify :lvs_min, :float, null: true
      modify :lvs_max, :float, null: true
    end
  end
end
