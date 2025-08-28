defmodule LvsTool.Repo.Migrations.AddOauthFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :provider, :string
      add :provider_id, :string
      add :avatar, :string
    end

    alter table(:users) do
      modify :hashed_password, :string, null: true
    end

    create index(:users, [:provider, :provider_id])
  end
end
