defmodule LvsTool.Repo.Migrations.RenameThesistypeIdToThesisTypeId do
  use Ecto.Migration

  def change do
    rename table(:theses_entries), :thesistype_id, to: :thesis_type_id
  end
end
