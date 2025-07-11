defmodule LvsTool.Courses.Studygroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "studygroups" do
    field :name, :string

    has_many :standard_course_entries, LvsTool.Courses.StandardCourseEntry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(studygroup, attrs) do
    studygroup
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
