defmodule LvsTool.Reductions do
  @moduledoc """
  The Reductions context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.Reductions.{ReductionType, ReductionEntry}

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

  @doc """
  Returns the list of reduction_entries for a specific semesterentry.
  """
  def list_reduction_entries_by_semesterentry(semesterentry_id) do
    Repo.all(from re in ReductionEntry, where: re.semesterentry_id == ^semesterentry_id)
    |> Repo.preload([:reduction_type])
  end

  @doc """
  Gets a single reduction_entry.
  """
  def get_reduction_entry!(id), do: Repo.get!(ReductionEntry, id)

  @doc """
  Creates a reduction_entry.
  """
  def create_reduction_entry(attrs \\ %{}) do
    %ReductionEntry{}
    |> ReductionEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reduction_entry.
  """
  def update_reduction_entry(%ReductionEntry{} = reduction_entry, attrs) do
    reduction_entry
    |> ReductionEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reduction_entry.
  """
  def delete_reduction_entry(%ReductionEntry{} = reduction_entry) do
    Repo.delete(reduction_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reduction_entry changes.
  """
  def change_reduction_entry(%ReductionEntry{} = reduction_entry, attrs \\ %{}) do
    ReductionEntry.changeset(reduction_entry, attrs)
  end

  def calculate_reduction_lvs(reduction_type_id) do
    if reduction_type_id && reduction_type_id != "" do
      reduction_type_id =
        if is_binary(reduction_type_id),
          do: String.to_integer(reduction_type_id),
          else: reduction_type_id

      reduction_type = get_reduction!(reduction_type_id).reduction_lvs
      reduction_type
    else
      0.0
    end
  end
end
