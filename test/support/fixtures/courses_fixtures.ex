defmodule LvsTool.CoursesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.Courses` context.
  """

  @doc """
  Generate a standardcoursetype.
  """
  def standardcoursetype_fixture(attrs \\ %{}) do
    {:ok, standardcoursetype} =
      attrs
      |> Enum.into(%{
        abbreviation: "some abbreviation",
        imputationfactor: 120.5,
        name: "some name"
      })
      |> LvsTool.Courses.create_standardcoursetype()

    standardcoursetype
  end
end
