defmodule LvsTool.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.Projects.ProjectEntry

  @doc """
  Returns the list of project_entries.

  ## Examples

      iex> list_project_entries()
      [%ProjectEntry{}, ...]

  """
  def list_project_entries do
    Repo.all(ProjectEntry)
    |> Repo.preload([:studygroups])
  end

  @doc """
  Gets a single project_entry.

  Raises `Ecto.NoResultsError` if the Project entry does not exist.

  ## Examples

      iex> get_project_entry!(123)
      %ProjectEntry{}

      iex> get_project_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_entry!(id) do
    Repo.get!(ProjectEntry, id)
    |> Repo.preload([:studygroups])
  end

  @doc """
  Creates a project_entry.

  ## Examples

      iex> create_project_entry(%{field: value})
      {:ok, %ProjectEntry{}}

      iex> create_project_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_entry(attrs \\ %{}) do
    %ProjectEntry{}
    |> ProjectEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_entry.

  ## Examples

      iex> update_project_entry(project_entry, %{field: new_value})
      {:ok, %ProjectEntry{}}

      iex> update_project_entry(project_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_entry(%ProjectEntry{} = project_entry, attrs) do
    project_entry
    |> ProjectEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project_entry.

  ## Examples

      iex> delete_project_entry(project_entry)
      {:ok, %ProjectEntry{}}

      iex> delete_project_entry(project_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_entry(%ProjectEntry{} = project_entry) do
    Repo.delete(project_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_entry changes.

  ## Examples

      iex> change_project_entry(project_entry)
      %Ecto.Changeset{data: %ProjectEntry{}}

  """
  def change_project_entry(%ProjectEntry{} = project_entry, attrs \\ %{}) do
    ProjectEntry.changeset(project_entry, attrs)
  end

  def list_project_entries_by_semesterentry(semesterentry_id) do
    Repo.all(from pe in ProjectEntry, where: pe.semesterentry_id == ^semesterentry_id)
    |> Repo.preload([:studygroups])
  end
end
