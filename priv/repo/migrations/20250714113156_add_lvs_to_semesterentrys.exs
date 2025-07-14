defmodule LvsTool.Repo.Migrations.AddLvsToSemesterentrys do
  use Ecto.Migration

  def change do
    alter table(:semesterentrys) do
      add :lvs_sum, :float, null: false, default: 0.0
    end
  end
end
