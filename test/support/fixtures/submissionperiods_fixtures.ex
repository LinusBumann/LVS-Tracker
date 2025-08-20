defmodule LvsTool.SubmissionperiodsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.Submissionperiods` context.
  """

  @doc """
  Generate a submissionperiod.
  """
  def submissionperiod_fixture(attrs \\ %{}) do
    {:ok, submissionperiod} =
      attrs
      |> Enum.into(%{
        enddate: ~U[2025-08-19 10:39:00Z],
        name: "some name",
        startdate: ~U[2025-08-19 10:39:00Z]
      })
      |> LvsTool.Submissionperiods.create_submissionperiod()

    submissionperiod
  end
end
