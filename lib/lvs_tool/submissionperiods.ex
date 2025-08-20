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
  def list_submissionperiods do
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
  def get_submissionperiod!(id), do: Repo.get!(SubmissionPeriod, id)

  @doc """
  Creates a submissionperiod.

  ## Examples

      iex> create_submissionperiod(%{field: value})
      {:ok, %Submissionperiod{}}

      iex> create_submissionperiod(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_submissionperiod(attrs \\ %{}) do
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
  def update_submissionperiod(%SubmissionPeriod{} = submissionperiod, attrs) do
    submissionperiod
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
  def delete_submissionperiod(%SubmissionPeriod{} = submissionperiod) do
    Repo.delete(submissionperiod)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking submissionperiod changes.

  ## Examples

      iex> change_submissionperiod(submissionperiod)
      %Ecto.Changeset{data: %Submissionperiod{}}

  """
  def change_submissionperiod(%SubmissionPeriod{} = submissionperiod, attrs \\ %{}) do
    SubmissionPeriod.changeset(submissionperiod, attrs)
  end
end
