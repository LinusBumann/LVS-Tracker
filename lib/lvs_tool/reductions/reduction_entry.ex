defmodule LvsTool.Reductions.ReductionEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reduction_entries" do
    field :lvs, :float

    belongs_to :semesterentry, LvsTool.Semesterentrys.Semesterentry
    belongs_to :reduction_type, LvsTool.Reductions.ReductionType

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reduction_entry, attrs) do
    reduction_entry
    |> cast(attrs, [:lvs, :semesterentry_id, :reduction_type_id])
    |> validate_required([:lvs, :semesterentry_id, :reduction_type_id])
  end
end
