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
end
