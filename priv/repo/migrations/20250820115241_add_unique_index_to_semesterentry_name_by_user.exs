defmodule LvsTool.Repo.Migrations.AddUniqueIndexToSemesterentryNameByUser do
  use Ecto.Migration

  def change do
    create unique_index(:semesterentrys, [:name, :user_id])
  end
end
