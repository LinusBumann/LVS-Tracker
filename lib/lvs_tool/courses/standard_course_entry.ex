defmodule LvsTool.Courses.StandardCourseEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "standard_course_entries" do
    field :kind, :string
    field :sws, :float
    field :student_count, :integer
    field :percent, :float
    field :lvs, :float

    # Liefert auch den Anrechnungsfaktor
    belongs_to :standardcoursetype, LvsTool.Courses.Standardcoursetype
    # Liefert den Kursnamen
    belongs_to :standardcoursename, LvsTool.Courses.Standardcoursename
    # Liefert die Studiengruppe
    belongs_to :studygroup, LvsTool.Courses.Studygroup

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(standard_course_entry, attrs) do
    standard_course_entry
    |> cast(attrs, [
      :kind,
      :sws,
      :student_count,
      :percent,
      :lvs,
      :standardcoursetype_id,
      :standardcoursename_id,
      :studygroup_id
    ])
    |> validate_required([
      :kind,
      :sws,
      :student_count,
      :percent,
      :lvs,
      :standardcoursetype_id,
      :standardcoursename_id,
      :studygroup_id
    ])
  end
end
