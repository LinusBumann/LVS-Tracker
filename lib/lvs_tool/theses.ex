defmodule LvsTool.Theses do
  @moduledoc """
  The Theses context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.Theses.ThesisType

  @doc """
  Returns the list of thesis_types.

  ## Examples

      iex> list_thesis_types()
      [%ThesisType{}, ...]

  """
  def list_thesis_types do
    Repo.all(ThesisType)
  end

  @doc """
  Gets a single thesis_type.

  Raises `Ecto.NoResultsError` if the Thesis type does not exist.

  ## Examples

      iex> get_thesis_type!(123)
      %ThesisType{}

      iex> get_thesis_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thesis_type!(id), do: Repo.get!(ThesisType, id)

  @doc """
  Creates a thesis_type.

  ## Examples

      iex> create_thesis_type(%{field: value})
      {:ok, %ThesisType{}}

      iex> create_thesis_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thesis_type(attrs \\ %{}) do
    %ThesisType{}
    |> ThesisType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a thesis_type.

  ## Examples

      iex> update_thesis_type(thesis_type, %{field: new_value})
      {:ok, %ThesisType{}}

      iex> update_thesis_type(thesis_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thesis_type(%ThesisType{} = thesis_type, attrs) do
    thesis_type
    |> ThesisType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a thesis_type.

  ## Examples

      iex> delete_thesis_type(thesis_type)
      {:ok, %ThesisType{}}

      iex> delete_thesis_type(thesis_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thesis_type(%ThesisType{} = thesis_type) do
    Repo.delete(thesis_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thesis_type changes.

  ## Examples

      iex> change_thesis_type(thesis_type)
      %Ecto.Changeset{data: %ThesisType{}}

  """
  def change_thesis_type(%ThesisType{} = thesis_type, attrs \\ %{}) do
    ThesisType.changeset(thesis_type, attrs)
  end

  alias LvsTool.Theses.ThesisEntry

  @doc """
  Returns the list of theses_entries.

  ## Examples

      iex> list_theses_entries()
      [%ThesisEntry{}, ...]

  """
  def list_theses_entries do
    Repo.all(ThesisEntry)
    |> Repo.preload([:thesis_type, :studygroups])
  end

  def list_theses_entries_by_semesterentry(semesterentry_id) do
    Repo.all(from te in ThesisEntry, where: te.semesterentry_id == ^semesterentry_id)
    |> Repo.preload([:thesis_type, :studygroups])
  end

  def get_thesis_count(semesterentry_id) do
    Repo.all(from te in ThesisEntry, where: te.semesterentry_id == ^semesterentry_id)
    |> length()
  end

  @doc """
  Gets a single thesis_entry.

  Raises `Ecto.NoResultsError` if the Thesis entry does not exist.

  ## Examples

      iex> get_thesis_entry!(123)
      %ThesisEntry{}

      iex> get_thesis_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thesis_entry!(id) do
    Repo.get!(ThesisEntry, id)
    |> Repo.preload([:thesis_type, :studygroups])
  end

  def calculate_thesis_lvs(percent, thesis_type_id) do
    if thesis_type_id && thesis_type_id != "" do
      thesis_type_id =
        if is_binary(thesis_type_id), do: String.to_integer(thesis_type_id), else: thesis_type_id

      imputationfactor = get_thesis_type!(thesis_type_id).imputationfactor
      {percent_int, _} = Integer.parse(percent)
      percent_int * imputationfactor / 100
    else
      0.0
    end
  end

  @doc """
  Creates a thesis_entry.

  ## Examples

      iex> create_thesis_entry(%{field: value})
      {:ok, %ThesisEntry{}}

      iex> create_thesis_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thesis_entry(attrs \\ %{}) do
    %ThesisEntry{}
    |> ThesisEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a thesis_entry.

  ## Examples

      iex> update_thesis_entry(thesis_entry, %{field: new_value})
      {:ok, %ThesisEntry{}}

      iex> update_thesis_entry(thesis_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thesis_entry(%ThesisEntry{} = thesis_entry, attrs) do
    thesis_entry
    |> ThesisEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a thesis_entry.

  ## Examples

      iex> delete_thesis_entry(thesis_entry)
      {:ok, %ThesisEntry{}}

      iex> delete_thesis_entry(thesis_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thesis_entry(%ThesisEntry{} = thesis_entry) do
    Repo.delete(thesis_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thesis_entry changes.

  ## Examples

      iex> change_thesis_entry(thesis_entry)
      %Ecto.Changeset{data: %ThesisEntry{}}

  """
  def change_thesis_entry(%ThesisEntry{} = thesis_entry, attrs \\ %{}) do
    ThesisEntry.changeset(thesis_entry, attrs)
  end
end
