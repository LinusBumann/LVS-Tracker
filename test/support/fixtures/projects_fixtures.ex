defmodule LvsTool.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.Projects` context.
  """

  @doc """
  Generate a project_entry.
  """
  def project_entry_fixture(attrs \\ %{}) do
    semesterentry = LvsTool.SemesterentrysFixtures.semesterentry_fixture()

    imputationfactor = 0.5
    sws = 4
    percent = 100
    calculated_lvs = sws * percent / imputationfactor

    {:ok, project_entry} =
      attrs
      |> Enum.into(%{
        name: "some name",
        kind: "some kind",
        lvs: calculated_lvs,
        percent: percent,
        student_count: 5,
        sws: sws,
        semesterentry_id: semesterentry.id
      })
      |> LvsTool.Projects.create_project_entry()

    project_entry
  end
end
