defmodule LvsTool.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      add :name, :string, null: false
      add :lvs_min, :integer, null: false
      add :lvs_max, :integer, null: false
      add :has_lvs, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
