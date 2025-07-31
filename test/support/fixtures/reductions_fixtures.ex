defmodule LvsTool.ReductionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.Reductions` context.
  """

  @doc """
  Generate a reduction.
  """
  def reduction_type_fixture(attrs \\ %{}) do
    {:ok, reduction_type} =
      attrs
      |> Enum.into(%{
        reduction_lvs: 120.5,
        reduction_reason: "some reduction_reason"
      })
      |> LvsTool.Reductions.create_reduction()

    reduction_type
  end
end
