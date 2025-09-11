defmodule LvsTool.Excursions do
  @moduledoc """
  The Excursions context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.Excursions.ExcursionEntry

  @doc """
  Returns the list of excursion_entries.

  ## Examples

      iex> list_excursion_entries()
      [%ExcursionEntry{}, ...]

  """
  def list_excursion_entries do
    Repo.all(ExcursionEntry)
  end

  def list_excursion_entries_by_semesterentry(semesterentry_id) do
    Repo.all(from e in ExcursionEntry, where: e.semesterentry_id == ^semesterentry_id)
    |> Repo.preload([:studygroups])
  end

  @doc """
  Gets a single excursion_entry.

  Raises `Ecto.NoResultsError` if the Excursion entry does not exist.

  ## Examples

      iex> get_excursion_entry!(123)
      %ExcursionEntry{}

      iex> get_excursion_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_excursion_entry!(id) do
    Repo.get!(ExcursionEntry, id)
    |> Repo.preload([:studygroups])
  end

  @doc """
  Creates a excursion_entry.

  ## Examples

      iex> create_excursion_entry(%{field: value})
      {:ok, %ExcursionEntry{}}

      iex> create_excursion_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_excursion_entry(attrs \\ %{}) do
    %ExcursionEntry{}
    |> ExcursionEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a excursion_entry.

  ## Examples

      iex> update_excursion_entry(excursion_entry, %{field: new_value})
      {:ok, %ExcursionEntry{}}

      iex> update_excursion_entry(excursion_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_excursion_entry(%ExcursionEntry{} = excursion_entry, attrs) do
    excursion_entry
    |> ExcursionEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a excursion_entry.

  ## Examples

      iex> delete_excursion_entry(excursion_entry)
      {:ok, %ExcursionEntry{}}

      iex> delete_excursion_entry(excursion_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_excursion_entry(%ExcursionEntry{} = excursion_entry) do
    Repo.delete(excursion_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking excursion_entry changes.

  ## Examples

      iex> change_excursion_entry(excursion_entry)
      %Ecto.Changeset{data: %ExcursionEntry{}}

  """
  def change_excursion_entry(%ExcursionEntry{} = excursion_entry, attrs \\ %{}) do
    ExcursionEntry.changeset(excursion_entry, attrs)
  end

  @doc """
  Berechnet die LVS für eine Exkursion basierend auf der maximalen täglichen Unterrichtseinheit und dem Anrechnungsfaktor.

  ## Beispiele

      iex> calculate_excursion_lvs(1, 8, 0.3)
      2.4

  """
  def calculate_excursion_lvs(day_count, daily_teaching_units, imputationfactor)
      when is_number(day_count) and is_number(daily_teaching_units) and
             is_number(imputationfactor) do
    semester_weeks = 15.0

    cond do
      day_count > 1 ->
        total_teaching_units = day_count * daily_teaching_units

        (imputationfactor * total_teaching_units / semester_weeks)
        |> Float.round(2)

      true ->
        (imputationfactor * daily_teaching_units / (0.75 * semester_weeks))
        |> Float.round(2)
    end
  end

  def calculate_excursion_lvs(_, _, _), do: 0.0

  def max_lvs_for_excursions_exceeded?(semesterentry_id) do
    all_excursions_lvs =
      from(ee in ExcursionEntry, where: ee.semesterentry_id == ^semesterentry_id)
      |> Repo.all()
      |> Enum.reduce(0, fn ee, acc -> acc + ee.lvs end)

    max_lvs = 2.0

    all_excursions_lvs > max_lvs
  end
end
