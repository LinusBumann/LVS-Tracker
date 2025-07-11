defmodule LvsTool.Repo.Migrations.ChangeDatatypeOfLvs do
  use Ecto.Migration

  def change do
    alter table(:user_roles) do
      modify :lvs_min, :float
      modify :lvs_max, :float
    end
  end
end
