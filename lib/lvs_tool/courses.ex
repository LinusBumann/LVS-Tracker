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
end
