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

  @doc """
  Berechnet die LVS für ein Projekt basierend auf SWS, Prozentanteil und Teilnehmerzahl.

  Bei weniger als 8 Studierenden wird ein reduzierter Faktor angewendet.

  ## Examples

      iex> calculate_project_lvs(4, 100, 8)
      4.0

      iex> calculate_project_lvs(4, 50, 6)
      1.5

  """
  def calculate_project_lvs(sws, percent, student_count)
      when is_binary(sws) and is_binary(percent) and is_binary(student_count) do
    case {Float.parse(sws), Float.parse(percent), Float.parse(student_count)} do
      {{sws_float, _}, {percent_float, _}, {student_count_float, _}} ->
        calculate_project_lvs(sws_float, percent_float, student_count_float)

      _ ->
        0.0
    end
  end

  def calculate_project_lvs(sws, percent, student_count)
      when is_number(sws) and is_number(percent) and is_number(student_count) do
    standard_project_student_count = 8

    cond do
      student_count < standard_project_student_count ->
        student_ratio = student_count / standard_project_student_count
        (student_ratio * sws * percent / 100.0) |> Float.round(2)

      true ->
        (sws * percent / 100.0) |> Float.round(2)
    end
  end

  def calculate_project_lvs(_, _, _), do: 0.0
end
