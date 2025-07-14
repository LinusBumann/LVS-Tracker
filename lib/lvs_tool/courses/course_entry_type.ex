defmodule LvsTool.Courses.CourseEntryType do
  @moduledoc """
  Das Schema `CourseEntryType` repräsentiert eine Verknüpfung zwischen einem Standardkurs-Eintrag und einem Standardkurs-Typ.
  """
  use Ecto.Schema

  schema "course_entry_types" do
    field :standard_course_entry_id, :id
    field :standardcoursetype_id, :id

    timestamps()
  end
end
