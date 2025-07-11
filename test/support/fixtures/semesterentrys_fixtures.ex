defmodule LvsTool.SemesterentrysFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.Semesterentrys` context.
  """

  @doc """
  Generate a semesterentry.
  """
  def semesterentry_fixture(attrs \\ %{}) do
    {:ok, semesterentry} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: "some status"
      })
      |> LvsTool.Semesterentrys.create_semesterentry()

    semesterentry
  end
end
