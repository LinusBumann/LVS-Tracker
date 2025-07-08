defmodule LvsTool.LehrdeputatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.Lehrdeputat` context.
  """

  @doc """
  Generate a semester.
  """
  def semester_fixture(attrs \\ %{}) do
    {:ok, semester} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> LvsTool.Lehrdeputat.create_semester()

    semester
  end
end
