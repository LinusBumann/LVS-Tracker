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

  def update_semesterentry_lvs(%Semesterentry{} = semesterentry, lvs_delta) do
    from(s in Semesterentry, where: s.id == ^semesterentry.id)
    |> Repo.update_all(inc: [lvs_sum: lvs_delta])
  end

  def recalculate_lvs_sum(%Semesterentry{} = semesterentry) do
    # Summe aller Standard-Kurs LVS
    standard_course_lvs_sum =
      from(sce in LvsTool.Courses.StandardCourseEntry,
        where: sce.semesterentry_id == ^semesterentry.id,
        select: coalesce(sum(sce.lvs), 0.0)
      )
      |> Repo.one()

    # Summe aller Thesis LVS
    thesis_lvs_sum =
      from(te in LvsTool.Theses.ThesisEntry,
        where: te.semesterentry_id == ^semesterentry.id,
        select: coalesce(sum(te.lvs), 0.0)
      )
      |> Repo.one()

    # Gesamtsumme berechnen und auf 2 Nachkommastellen runden
    total_lvs = Float.round(standard_course_lvs_sum + thesis_lvs_sum, 2)

    # Sicherstellen, dass die Summe nicht negativ wird
    final_lvs = max(total_lvs, 0.0)

    # Update der LVS-Summe
    from(s in Semesterentry, where: s.id == ^semesterentry.id)
    |> Repo.update_all(set: [lvs_sum: final_lvs])

    # Aktualisierte semesterentry zurückgeben
    get_semesterentry!(semesterentry.id)
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
