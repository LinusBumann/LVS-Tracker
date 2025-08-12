defmodule LvsTool.ThesesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.Theses` context.
  """

  @doc """
  Generate a thesis_type.
  """
  def thesis_type_fixture(attrs \\ %{}) do
    {:ok, thesis_type} =
      attrs
      |> Enum.into(%{
        imputationfactor: 120.5,
        name: "some name"
      })
      |> LvsTool.Theses.create_thesis_type()

    thesis_type
  end

  @doc """
  Generate a thesis_entry.
  """
  def thesis_entry_fixture(attrs \\ %{}) do
    {:ok, thesis_entry} =
      attrs
      |> Enum.into(%{
        percent: 120.5,
        studygroup: "some studygroup",
        type: "some type"
      })
      |> LvsTool.Theses.create_thesis_entry()

    thesis_entry
  end
end
