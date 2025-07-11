defmodule LvsTool.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.Courses.Standardcoursetype

  @doc """
  Returns the list of standardcoursetypes.

  ## Examples

      iex> list_standardcoursetypes()
      [%Standardcoursetype{}, ...]

  """
  def list_standardcoursetypes do
    Repo.all(Standardcoursetype)
  end

  @doc """
  Gets a single standardcoursetype.

  Raises `Ecto.NoResultsError` if the Standardcoursetype does not exist.

  ## Examples

      iex> get_standardcoursetype!(123)
      %Standardcoursetype{}

      iex> get_standardcoursetype!(456)
      ** (Ecto.NoResultsError)

  """
  def get_standardcoursetype!(id), do: Repo.get!(Standardcoursetype, id)

  @doc """
  Creates a standardcoursetype.

  ## Examples

      iex> create_standardcoursetype(%{field: value})
      {:ok, %Standardcoursetype{}}

      iex> create_standardcoursetype(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_standardcoursetype(attrs \\ %{}) do
    %Standardcoursetype{}
    |> Standardcoursetype.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a standardcoursetype.

  ## Examples

      iex> update_standardcoursetype(standardcoursetype, %{field: new_value})
      {:ok, %Standardcoursetype{}}

      iex> update_standardcoursetype(standardcoursetype, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_standardcoursetype(%Standardcoursetype{} = standardcoursetype, attrs) do
    standardcoursetype
    |> Standardcoursetype.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a standardcoursetype.

  ## Examples

      iex> delete_standardcoursetype(standardcoursetype)
      {:ok, %Standardcoursetype{}}

      iex> delete_standardcoursetype(standardcoursetype)
      {:error, %Ecto.Changeset{}}

  """
  def delete_standardcoursetype(%Standardcoursetype{} = standardcoursetype) do
    Repo.delete(standardcoursetype)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking standardcoursetype changes.

  ## Examples

      iex> change_standardcoursetype(standardcoursetype)
      %Ecto.Changeset{data: %Standardcoursetype{}}

  """
  def change_standardcoursetype(%Standardcoursetype{} = standardcoursetype, attrs \\ %{}) do
    Standardcoursetype.changeset(standardcoursetype, attrs)
  end

  alias LvsTool.Courses.Standardcoursename

  @doc """
  Returns the list of standardcoursenames.

  ## Examples

      iex> list_standardcoursenames()
      [%Standardcoursename{}, ...]

  """
  def list_standardcoursenames do
    Repo.all(Standardcoursename)
  end

  @doc """
  Gets a single standardcoursename.

  Raises `Ecto.NoResultsError` if the Standardcoursename does not exist.

  ## Examples

      iex> get_standardcoursename!(123)
      %Standardcoursename{}

      iex> get_standardcoursename!(456)
      ** (Ecto.NoResultsError)

  """
  def get_standardcoursename!(id), do: Repo.get!(Standardcoursename, id)

  @doc """
  Creates a standardcoursename.

  ## Examples

      iex> create_standardcoursename(%{field: value})
      {:ok, %Standardcoursename{}}

      iex> create_standardcoursename(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_standardcoursename(attrs \\ %{}) do
    %Standardcoursename{}
    |> Standardcoursename.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a standardcoursename.

  ## Examples

      iex> update_standardcoursename(standardcoursename, %{field: new_value})
      {:ok, %Standardcoursename{}}

      iex> update_standardcoursename(standardcoursename, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_standardcoursename(%Standardcoursename{} = standardcoursename, attrs) do
    standardcoursename
    |> Standardcoursename.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a standardcoursename.

  ## Examples

      iex> delete_standardcoursename(standardcoursename)
      {:ok, %Standardcoursename{}}

      iex> delete_standardcoursename(standardcoursename)
      {:error, %Ecto.Changeset{}}

  """
  def delete_standardcoursename(%Standardcoursename{} = standardcoursename) do
    Repo.delete(standardcoursename)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking standardcoursename changes.

  ## Examples

      iex> change_standardcoursename(standardcoursename)
      %Ecto.Changeset{data: %Standardcoursename{}}

  """
  def change_standardcoursename(%Standardcoursename{} = standardcoursename, attrs \\ %{}) do
    Standardcoursename.changeset(standardcoursename, attrs)
  end

  alias LvsTool.Courses.Studygroup

  @doc """
  Returns the list of studygroups.

  ## Examples

      iex> list_studygroups()
      [%Studygroup{}, ...]

  """
  def list_studygroups do
    Repo.all(Studygroup)
  end

  @doc """
  Gets a single studygroup.

  Raises `Ecto.NoResultsError` if the Studygroup does not exist.

  ## Examples

      iex> get_studygroup!(123)
      %Studygroup{}

      iex> get_studygroup!(456)
      ** (Ecto.NoResultsError)

  """
  def get_studygroup!(id), do: Repo.get!(Studygroup, id)

  @doc """
  Creates a studygroup.

  ## Examples

      iex> create_studygroup(%{field: value})
      {:ok, %Studygroup{}}

      iex> create_studygroup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_studygroup(attrs \\ %{}) do
    %Studygroup{}
    |> Studygroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a studygroup.

  ## Examples

      iex> update_studygroup(studygroup, %{field: new_value})
      {:ok, %Studygroup{}}

      iex> update_studygroup(studygroup, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_studygroup(%Studygroup{} = studygroup, attrs) do
    studygroup
    |> Studygroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a studygroup.

  ## Examples

      iex> delete_studygroup(studygroup)
      {:ok, %Studygroup{}}

      iex> delete_studygroup(studygroup)
      {:error, %Ecto.Changeset{}}

  """
  def delete_studygroup(%Studygroup{} = studygroup) do
    Repo.delete(studygroup)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking studygroup changes.

  ## Examples

      iex> change_studygroup(studygroup)
      %Ecto.Changeset{data: %Studygroup{}}

  """
  def change_studygroup(%Studygroup{} = studygroup, attrs \\ %{}) do
    Studygroup.changeset(studygroup, attrs)
  end
end
