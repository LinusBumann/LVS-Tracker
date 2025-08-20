defmodule LvsTool.SubmissionPeriods do
  @moduledoc """
  The Submissionperiods context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.SubmissionPeriods.SubmissionPeriod

  @doc """
  Returns the list of submissionperiods.

  ## Examples

      iex> list_submissionperiods()
      [%Submissionperiod{}, ...]

  """
  def list_submission_periods do
    Repo.all(SubmissionPeriod)
  end

  @doc """
  Gets a single submissionperiod.

  Raises `Ecto.NoResultsError` if the Submissionperiod does not exist.

  ## Examples

      iex> get_submissionperiod!(123)
      %Submissionperiod{}

      iex> get_submissionperiod!(456)
      ** (Ecto.NoResultsError)

  """
  def get_submission_period!(id), do: Repo.get!(SubmissionPeriod, id)

  @doc """
  Creates a submissionperiod.

  ## Examples

      iex> create_submissionperiod(%{field: value})
      {:ok, %Submissionperiod{}}

      iex> create_submissionperiod(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_submission_period(attrs \\ %{}) do
    %SubmissionPeriod{}
    |> SubmissionPeriod.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a submissionperiod.

  ## Examples

      iex> update_submissionperiod(submissionperiod, %{field: new_value})
      {:ok, %Submissionperiod{}}

      iex> update_submissionperiod(submissionperiod, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_submission_period(%SubmissionPeriod{} = submission_period, attrs) do
    submission_period
    |> SubmissionPeriod.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a submissionperiod.

  ## Examples

      iex> delete_submissionperiod(submissionperiod)
      {:ok, %Submissionperiod{}}

      iex> delete_submissionperiod(submissionperiod)
      {:error, %Ecto.Changeset{}}

  """
  def delete_submission_period(%SubmissionPeriod{} = submission_period) do
    Repo.delete(submission_period)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking submissionperiod changes.

  ## Examples

      iex> change_submissionperiod(submissionperiod)
      %Ecto.Changeset{data: %Submissionperiod{}}

  """
  def change_submission_period(%SubmissionPeriod{} = submission_period, attrs \\ %{}) do
    SubmissionPeriod.changeset(submission_period, attrs)
  end
end
