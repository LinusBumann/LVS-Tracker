defmodule LvsTool.Reductions do
  @moduledoc """
  The Reductions context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.Reductions.ReductionType

  @doc """
  Returns the list of reduction_types.

  ## Examples

      iex> list_reduction_types()
      [%Reduction{}, ...]

  """
  def list_reduction_types do
    Repo.all(ReductionType)
  end

  @doc """
  Gets a single reduction.

  Raises `Ecto.NoResultsError` if the Reduction does not exist.

  ## Examples

      iex> get_reduction!(123)
      %Reduction{}

      iex> get_reduction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reduction!(id), do: Repo.get!(ReductionType, id)

  @doc """
  Creates a reduction.

  ## Examples

      iex> create_reduction(%{field: value})
      {:ok, %Reduction{}}

      iex> create_reduction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reduction(attrs \\ %{}) do
    %ReductionType{}
    |> ReductionType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reduction.

  ## Examples

      iex> update_reduction(reduction, %{field: new_value})
      {:ok, %Reduction{}}

      iex> update_reduction(reduction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reduction(%ReductionType{} = reduction_type, attrs) do
    reduction_type
    |> ReductionType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reduction.

  ## Examples

      iex> delete_reduction(reduction)
      {:ok, %Reduction{}}

      iex> delete_reduction(reduction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reduction(%ReductionType{} = reduction_type) do
    Repo.delete(reduction_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reduction changes.

  ## Examples

      iex> change_reduction(reduction)
      %Ecto.Changeset{data: %Reduction{}}

  """
  def change_reduction(%ReductionType{} = reduction_type, attrs \\ %{}) do
    ReductionType.changeset(reduction_type, attrs)
  end

  alias LvsTool.Reductions.ReductionEntry

  @doc """
  Returns the list of reduction_entrie.

  ## Examples

      iex> list_reduction_entrie()
      [%ReductionEntry{}, ...]

  """
  def list_reduction_entrie do
    Repo.all(ReductionEntry)
  end

  @doc """
  Gets a single reduction_entry.

  Raises `Ecto.NoResultsError` if the Reduction entry does not exist.

  ## Examples

      iex> get_reduction_entry!(123)
      %ReductionEntry{}

      iex> get_reduction_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reduction_entry!(id), do: Repo.get!(ReductionEntry, id)

  @doc """
  Creates a reduction_entry.

  ## Examples

      iex> create_reduction_entry(%{field: value})
      {:ok, %ReductionEntry{}}

      iex> create_reduction_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reduction_entry(attrs \\ %{}) do
    %ReductionEntry{}
    |> ReductionEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reduction_entry.

  ## Examples

      iex> update_reduction_entry(reduction_entry, %{field: new_value})
      {:ok, %ReductionEntry{}}

      iex> update_reduction_entry(reduction_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reduction_entry(%ReductionEntry{} = reduction_entry, attrs) do
    reduction_entry
    |> ReductionEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reduction_entry.

  ## Examples

      iex> delete_reduction_entry(reduction_entry)
      {:ok, %ReductionEntry{}}

      iex> delete_reduction_entry(reduction_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reduction_entry(%ReductionEntry{} = reduction_entry) do
    Repo.delete(reduction_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reduction_entry changes.

  ## Examples

      iex> change_reduction_entry(reduction_entry)
      %Ecto.Changeset{data: %ReductionEntry{}}

  """
  def change_reduction_entry(%ReductionEntry{} = reduction_entry, attrs \\ %{}) do
    ReductionEntry.changeset(reduction_entry, attrs)
  end
end
