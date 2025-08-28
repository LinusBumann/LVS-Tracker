defmodule LvsTool.Repo.Migrations.AddOauthFieldsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
      add :formatted_name, :string
      add :family_name, :string
      add :given_name, :string
      add :name_prefix, :string
      add :name_suffix, :string
      add :studip_permission, :string
      add :phone, :string
      add :homepage, :string
      add :address, :text
    end

    # Index für StudIP Username
    create index(:users, [:username])
    create index(:users, [:studip_permission])
  end
end
