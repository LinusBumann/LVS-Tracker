defmodule LvsTool.Repo.Migrations.AddThesesNumberFieldToSemesterEntry do
  use Ecto.Migration

  def change do
    alter table(:semesterentrys) do
      add :theses_count, :integer, null: false, default: 0
    end
  end
end
