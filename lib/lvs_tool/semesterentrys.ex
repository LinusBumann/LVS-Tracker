defmodule LvsTool.Semesterentrys do
  @moduledoc """
  The Semesterentrys context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.Semesterentrys.Semesterentry

  @doc """
  Returns the list of semesterentrys.

  ## Examples

      iex> list_semesterentrys()
      [%Semesterentry{}, ...]

  """
  def list_semesterentrys do
    Repo.all(Semesterentry)
  end

  def list_semesterentrys_by_user(user_id) do
    Repo.all(from s in Semesterentry, where: s.user_id == ^user_id)
  end

  @doc """
  Gets a single semesterentry.

  Raises `Ecto.NoResultsError` if the Semesterentry does not exist.

  ## Examples

      iex> get_semesterentry!(123)
      %Semesterentry{}

      iex> get_semesterentry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_semesterentry!(id) do
    Repo.get!(Semesterentry, id)
    |> Repo.preload(
      standard_course_entries: [
        :standardcoursename,
        :standardcoursetypes,
        :studygroups
      ]
    )
  end

  @doc """
  Creates a semesterentry.

  ## Examples

      iex> create_semesterentry(%{field: value})
      {:ok, %Semesterentry{}}

      iex> create_semesterentry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_semesterentry(attrs \\ %{}) do
    %Semesterentry{}
    |> Semesterentry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a semesterentry.

  ## Examples

      iex> update_semesterentry(semesterentry, %{field: new_value})
      {:ok, %Semesterentry{}}

      iex> update_semesterentry(semesterentry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_semesterentry(%Semesterentry{} = semesterentry, attrs) do
    semesterentry
    |> Semesterentry.changeset(attrs)
    |> Repo.update()
  end

  def calculate_lvs_update(current_lvs_sum, old_lvs, new_lvs) do
    current_lvs_sum + new_lvs - old_lvs
  end

  @doc """
  Deletes a semesterentry.

  ## Examples

      iex> delete_semesterentry(semesterentry)
      {:ok, %Semesterentry{}}

      iex> delete_semesterentry(semesterentry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_semesterentry(%Semesterentry{} = semesterentry) do
    Repo.delete(semesterentry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking semesterentry changes.

  ## Examples

      iex> change_semesterentry(semesterentry)
      %Ecto.Changeset{data: %Semesterentry{}}

  """
  def change_semesterentry(%Semesterentry{} = semesterentry, attrs \\ %{}) do
    Semesterentry.changeset(semesterentry, attrs)
  end
end
