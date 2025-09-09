defmodule LvsTool.Semesterentrys do
  @moduledoc """
  The Semesterentrys context.
  """

  import Ecto.Query, warn: false
  alias LvsTool.Repo

  alias LvsTool.Semesterentrys.Semesterentry
  alias LvsTool.Theses
  alias LvsTool.Accounts

  @doc """
  Returns the list of semesterentrys.

  ## Examples

      iex> list_semesterentrys()
      [%Semesterentry{}, ...]

  """
  def list_semesterentrys do
    Repo.all(Semesterentry)
  end

  @doc """
  Returns the semesterentries for the given user (teachers).
  """
  def retrieve_semesterentries_for_teachers(user_id) do
    Repo.all(from s in Semesterentry, where: s.user_id == ^user_id)
  end

  def retrieve_semesterentries_for_dekanat() do
    from(s in Semesterentry,
      where:
        s.status in [
          "Eingereicht"
        ],
      preload: [:user]
    )
    |> Repo.all()
  end

  def retrieve_semesterentries_for_presidium() do
    from(s in Semesterentry,
      where: s.status in ["An das Präsidium weitergeleitet", "Akzeptiert"],
      preload: [:user]
    )
    |> Repo.all()
  end

  @doc """
  Returns the semesterentries that are visible for the given role.
  """
  @teaching_role_ids [1, 2, 3, 4, 5]
  @dekanat_role_id 6
  @presidium_role_id 7
  def list_visible_semesterentrys_for_role(role_id, user_id) do
    case role_id do
      # Lehrende sehen nur ihre eigenen Einträge
      role
      when role in @teaching_role_ids ->
        retrieve_semesterentries_for_teachers(user_id)

      # Dekanat sieht nur eingereichte Einträge (nicht "Offen")
      @dekanat_role_id ->
        retrieve_semesterentries_for_dekanat()

      # Präsidium sieht nur Einträge, die vom Dekanat weitergeleitet wurden
      @presidium_role_id ->
        retrieve_semesterentries_for_presidium()

      _ ->
        []
    end
  end

  def get_lvs_requirements_for_display(current_user, user_role, semesterentry) do
    case user_role.id do
      # Für Dekanat und Präsidium: Zeige Anforderungen des Semesterentry-Besitzers
      role_id when role_id in [6, 7] ->
        semesterentry_owner = Accounts.get_user!(semesterentry.user_id)

        Accounts.get_user_lvs_requirements_with_reduction_calculation(
          semesterentry_owner,
          semesterentry.id
        )

      # Für alle anderen: Zeige eigene Anforderungen
      _ ->
        Accounts.get_user_lvs_requirements_with_reduction_calculation(
          current_user,
          semesterentry.id
        )
    end
  end

  @doc """
  Checks if a semesterentry is visible for the given role.
  """
  def visible_for_role?(semesterentry, user_role, current_user_id \\ nil) do
    case user_role do
      # Lehrende sehen nur ihre eigenen Einträge
      role
      when role in [
             "Professor/in (allgemein)",
             "Lehrkraft für besondere Aufgaben",
             "Wissenschaftliche/r Mitarbeiter/in",
             "Wissenschaftl. MA (befristet, Qualauftrag)",
             "Prof. bei gemeinsamer Berufung"
           ] ->
        semesterentry.user_id == current_user_id

      # Dekanat sieht eingereichte Einträge
      "Dekanat" ->
        semesterentry.status in [
          "Eingereicht",
          "An das Präsidium weitergeleitet",
          "Akzeptiert"
        ]

      # Präsidium sieht nur weitergeleitete Einträge
      "Präsidium" ->
        semesterentry.status in ["An das Präsidium weitergeleitet", "Akzeptiert"]

      _ ->
        false
    end
  end

  @doc """
  Returns the possible status transitions for a role.
  """
  def allowed_status_transitions(current_status, user_role) do
    case user_role do
      # Lehrende können nur von "Offen" zu "Eingereicht" wechseln
      role
      when role in [
             "Professor/in (allgemein)",
             "Lehrkraft für besondere Aufgaben",
             "Wissenschaftliche/r Mitarbeiter/in",
             "Wissenschaftl. MA (befristet, Qualauftrag)",
             "Prof. bei gemeinsamer Berufung"
           ] ->
        case current_status do
          "Offen" -> ["Eingereicht"]
          # Erneut einreichen nach Ablehnung
          "Abgelehnt" -> ["Eingereicht"]
          _ -> []
        end

      # Dekanat kann bestätigen, ablehnen oder weiterleiten
      "Dekanat" ->
        case current_status do
          "Eingereicht" -> ["Abgelehnt", "An das Präsidium weitergeleitet"]
          _ -> []
        end

      # Präsidium kann akzeptieren oder ablehnen
      "Präsidium" ->
        case current_status do
          "An das Präsidium weitergeleitet" -> ["Akzeptiert", "Abgelehnt"]
          _ -> []
        end

      _ ->
        []
    end
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

  def get_lvs_for_semesterentry(semesterentry_id) do
    from(s in Semesterentry, where: s.id == ^semesterentry_id)
    |> Repo.one()
    |> Map.get(:lvs_sum)
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

  @doc """
  Updates the status of a semesterentry to 'An das Präsidium weitergeleitet'.
  """
  def forward_to_presidium(%Semesterentry{} = semesterentry) do
    update_semesterentry(semesterentry, %{status: "An das Präsidium weitergeleitet"})
  end

  @doc """
  Updates the status of a semesterentry to 'Akzeptiert'.
  """
  def approve_semesterentry(%Semesterentry{} = semesterentry) do
    update_semesterentry(semesterentry, %{status: "Akzeptiert"})
  end

  @doc """
  Updates the status of a semesterentry to 'Abgelehnt'.
  """
  def reject_semesterentry(%Semesterentry{} = semesterentry) do
    update_semesterentry(semesterentry, %{status: "Abgelehnt"})
  end

  def update_semesterentry_lvs(%Semesterentry{} = semesterentry, lvs_delta) do
    from(s in Semesterentry, where: s.id == ^semesterentry.id)
    |> Repo.update_all(inc: [lvs_sum: lvs_delta])
  end

  def update_theses_count(%Semesterentry{} = semesterentry) do
    thesis_count = Theses.get_thesis_count(semesterentry.id)

    from(s in Semesterentry, where: s.id == ^semesterentry.id)
    |> Repo.update_all(set: [theses_count: thesis_count])

    get_semesterentry!(semesterentry.id)
  end

  def calculate_lvs_sum_for_all_semesterentries_by_user(user_id) do
    semesterentries = retrieve_semesterentries_for_teachers(user_id)

    semesterentries
    |> Enum.map(fn semesterentry -> semesterentry.lvs_sum end)
    |> Enum.sum()
  end

  def recalculate_lvs_sum(%Semesterentry{} = semesterentry) do
    standard_course_lvs_sum =
      from(sce in LvsTool.Courses.StandardCourseEntry,
        where: sce.semesterentry_id == ^semesterentry.id,
        select: coalesce(sum(sce.lvs), 0.0)
      )
      |> Repo.one()

    # Summe aller Thesis LVS
    thesis_count = Theses.get_thesis_count(semesterentry.id)

    thesis_lvs_sum =
      cond do
        Theses.max_lvs_for_theses_exceeded?(semesterentry.id) ->
          3.0

        thesis_count >= 6 ->
          from(te in Theses.ThesisEntry,
            where: te.semesterentry_id == ^semesterentry.id,
            select: coalesce(sum(te.lvs), 0.0)
          )
          |> Repo.one()

        true ->
          0.0
      end

    # Gesamtsumme berechnen (Standard-Kurse + Theses - Reduktionen) und auf 2 Nachkommastellen runden
    total_lvs = Float.round(standard_course_lvs_sum + thesis_lvs_sum, 2)

    # Update der LVS-Summe
    from(s in Semesterentry, where: s.id == ^semesterentry.id)
    |> Repo.update_all(set: [lvs_sum: total_lvs])

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
