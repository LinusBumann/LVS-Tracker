defmodule LvsTool.SubmissionperiodsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvsTool.SubmissionPeriods` context.
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
      |> LvsTool.SubmissionPeriods.create_submission_period()

    submissionperiod
  end
end
