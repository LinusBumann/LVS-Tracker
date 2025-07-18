defmodule LvsTool.Semesterentrys.Semesterentry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "semesterentrys" do
    field :name, :string
    field :status, :string
    field :lvs_sum, :float, default: 0.0

    belongs_to :user, LvsTool.Accounts.User

    has_many :standard_course_entries, LvsTool.Courses.StandardCourseEntry

    # TODO: Add project, excursion, thesis, reduction entries
    # has_many :project_entries, LvsTool.Semesterentrys.ProjectEntry
    # has_many :excursion_entries, LvsTool.Semesterentrys.ExcursionEntry
    # has_many :thesis_entries, LvsTool.Semesterentrys.ThesisEntry
    # has_many :reduction_entries, LvsTool.Semesterentrys.ReductionEntry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(semesterentry, attrs) do
    semesterentry
    |> cast(attrs, [:name, :status, :user_id, :lvs_sum])
    |> validate_required([:name, :status, :user_id, :lvs_sum])
  end
end
