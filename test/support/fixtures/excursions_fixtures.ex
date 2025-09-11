defmodule LvsTool.ExcursionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.Excursions` context.
  """

  @doc """
  Generate a excursion_entry.
  """
  def excursion_entry_fixture(attrs \\ %{}) do
    {:ok, excursion_entry} =
      attrs
      |> Enum.into(%{
        imputationfactor: 0.3,
        lvs: 4,
        name: "some name",
        student_count: 30,
        daily_max_teaching_units: 10
      })
      |> LvsTool.Excursions.create_excursion_entry()

    excursion_entry
  end
end
