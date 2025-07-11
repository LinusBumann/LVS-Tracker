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

  @doc """
  Generate a unique standardcoursename name.
  """
  def unique_standardcoursename_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a standardcoursename.
  """
  def standardcoursename_fixture(attrs \\ %{}) do
    {:ok, standardcoursename} =
      attrs
      |> Enum.into(%{
        name: unique_standardcoursename_name()
      })
      |> LvsTool.Courses.create_standardcoursename()

    standardcoursename
  end

  @doc """
  Generate a unique studygroup name.
  """
  def unique_studygroup_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a studygroup.
  """
  def studygroup_fixture(attrs \\ %{}) do
    {:ok, studygroup} =
      attrs
      |> Enum.into(%{
        name: unique_studygroup_name()
      })
      |> LvsTool.Courses.create_studygroup()

    studygroup
  end
end
