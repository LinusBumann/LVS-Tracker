defmodule LvsTool.Courses.CourseEntryStudygroup do
  @moduledoc """
  Das Schema `CourseEntryStudygroup` repräsentiert eine Verknüpfung zwischen einem Standardkurs-Eintrag und einer Studiengruppe.
  """
  use Ecto.Schema

  schema "course_entry_studygroups" do
    field :standard_course_entry_id, :id
    field :studygroup_id, :id
  end
end
