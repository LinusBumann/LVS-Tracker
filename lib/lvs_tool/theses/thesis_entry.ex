defmodule LvsTool.Theses.ThesisEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "theses_entries" do
    field :percent, :float
    field :lvs, :float

    belongs_to :semesterentry, LvsTool.Semesterentrys.Semesterentry

    many_to_many :thesis_types, LvsTool.Theses.ThesisType,
      join_through: "thesis_entry_types",
      on_replace: :delete

    many_to_many :studygroups, LvsTool.Courses.Studygroup,
      join_through: "thesis_entry_studygroups",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thesis_entry, attrs) do
    thesis_entry
    |> cast(attrs, [:percent, :lvs, :semesterentry_id])
    |> validate_required([:percent, :lvs, :semesterentry_id])
  end
end
