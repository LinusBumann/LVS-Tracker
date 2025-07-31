defmodule LvsTool.Reductions do
  @moduledoc """
  The Reductions context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.Reductions.Reduction

  @doc """
  Returns the list of reduction_types.

  ## Examples

      iex> list_reduction_types()
      [%Reduction{}, ...]

  """
  def list_reduction_types do
    Repo.all(Reduction)
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
  def get_reduction!(id), do: Repo.get!(Reduction, id)

  @doc """
  Creates a reduction.

  ## Examples

      iex> create_reduction(%{field: value})
      {:ok, %Reduction{}}

      iex> create_reduction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reduction(attrs \\ %{}) do
    %Reduction{}
    |> Reduction.changeset(attrs)
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
  def update_reduction(%Reduction{} = reduction, attrs) do
    reduction
    |> Reduction.changeset(attrs)
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
  def delete_reduction(%Reduction{} = reduction) do
    Repo.delete(reduction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reduction changes.

  ## Examples

      iex> change_reduction(reduction)
      %Ecto.Changeset{data: %Reduction{}}

  """
  def change_reduction(%Reduction{} = reduction, attrs \\ %{}) do
    Reduction.changeset(reduction, attrs)
  end
end
