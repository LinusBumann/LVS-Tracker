defmodule LvsTool.Semesterentrys.Semesterentry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "semesterentrys" do
    field :name, :string
    field :status, :string, default: "Offen"
    field :lvs_sum, :float, default: 0.0
    field :theses_count, :integer, default: 0

    belongs_to :user, LvsTool.Accounts.User

    has_many :standard_course_entries, LvsTool.Courses.StandardCourseEntry
    has_many :thesis_entries, LvsTool.Theses.ThesisEntry
    has_many :reduction_entries, LvsTool.Reductions.ReductionEntry
    has_many :project_entries, LvsTool.Projects.ProjectEntry
    has_many :excursion_entries, LvsTool.Excursions.ExcursionEntry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(semesterentry, attrs) do
    semesterentry
    |> cast(attrs, [:name, :status, :user_id, :lvs_sum, :theses_count])
    |> validate_required([:name, :status, :user_id, :lvs_sum])
    |> unique_constraint([:name, :user_id],
      message: "Sie haben bereits einen Eintrag für dieses Semester"
    )
  end
end
