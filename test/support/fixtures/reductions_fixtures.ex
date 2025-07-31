defmodule LvsTool.ReductionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.Reductions` context.
  """

  @doc """
  Generate a reduction.
  """
  def reduction_fixture(attrs \\ %{}) do
    {:ok, reduction} =
      attrs
      |> Enum.into(%{
        reduction_lvs: 120.5,
        reduction_reason: "some reduction_reason"
      })
      |> LvsTool.Reductions.create_reduction()

    reduction
  end
end
