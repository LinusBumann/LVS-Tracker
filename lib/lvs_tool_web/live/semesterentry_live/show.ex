defmodule LvsToolWeb.SemesterentryLive.Show do
  use LvsToolWeb, :live_view

  alias LvsTool.Semesterentrys
  alias Phoenix.LiveView.JS
  alias LvsTool.Courses
  alias LvsTool.Courses.StandardCourseEntry
  alias LvsTool.Theses
  alias LvsTool.Theses.ThesisEntry
  alias LvsTool.Accounts
  alias LvsTool.Reductions
  alias LvsToolWeb.RoleHelpers

  @impl true
  def mount(params, _session, socket) do
    # Hole den Semesterentry um den Besitzer zu identifizieren
    semesterentry = Semesterentrys.get_semesterentry!(params["id"])

    # Bestimme für welchen Benutzer die LVS-Anforderungen berechnet werden sollen
    {target_user, semesterentry_owner} =
      case socket.assigns.current_user |> Accounts.get_user_role() do
        # Für Dekanat: Zeige Informationen des Semesterentry-Besitzers
        %{id: 6} ->
          owner = Accounts.get_user!(semesterentry.user_id)
          {owner, owner}

        # Für Präsidium: Zeige Informationen des Semesterentry-Besitzers
        %{id: 7} ->
          owner = Accounts.get_user!(semesterentry.user_id)
          {owner, owner}

        # Für alle anderen: Zeige eigene Informationen
        _ ->
          {socket.assigns.current_user, nil}
      end

    {:ok,
     socket
     |> stream(:standard_course_entries, [], reset: true)
     |> stream(:thesis_entries, [], reset: true)
     |> stream(:reduction_entries, [], reset: true)
     |> assign(
       :calculated_user_lvs_requirements,
       Accounts.get_user_lvs_requirements_with_reduction_calculation(
         target_user,
         params["id"]
       )
     )
     |> assign(
       :user_lvs_requirements,
       Accounts.get_user_lvs_requirements(target_user)
     )
     |> assign(:user_role, Accounts.get_user_role(socket.assigns.current_user))
     |> assign(:semesterentry_owner, semesterentry_owner)
     |> IO.inspect()}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # Helper-Funktion für Templates
  def is_role?(user_role, role_name), do: RoleHelpers.is_role?(user_role, role_name)

  defp apply_action(socket, :show, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    standard_course_entries =
      Courses.list_standard_course_entries_by_semesterentry(semesterentry.id)

    thesis_entries = Theses.list_theses_entries_by_semesterentry(semesterentry.id)

    socket
    |> assign(:page_title, "Show Semesterentry")
    |> assign(:semesterentry, semesterentry)
    |> stream(:standard_course_entries, standard_course_entries, reset: true)
    |> stream(:thesis_entries, thesis_entries, reset: true)
  end

  # Neue apply_action Funktionen für Tab-spezifische Routen
  defp apply_action(socket, :show_standard_courses, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    standard_course_entries =
      Courses.list_standard_course_entries_by_semesterentry(semesterentry.id)

    socket
    |> assign(:page_title, "Standard-Kurse")
    |> assign(:semesterentry, semesterentry)
    |> stream(:standard_course_entries, standard_course_entries, reset: true)
  end

  defp apply_action(socket, :show_thesis, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    thesis_entries = Theses.list_theses_entries_by_semesterentry(semesterentry.id)

    socket
    |> assign(:page_title, "Thesis")
    |> assign(:semesterentry, semesterentry)
    |> stream(:thesis_entries, thesis_entries, reset: true)
  end

  defp apply_action(socket, :show_projects, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    socket
    |> assign(:page_title, "Projekte")
    |> assign(:semesterentry, semesterentry)
  end

  defp apply_action(socket, :show_excursions, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    socket
    |> assign(:page_title, "Exkursionen")
    |> assign(:semesterentry, semesterentry)
  end

  defp apply_action(socket, :show_reductions, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    reduction_entries = Reductions.list_reduction_entries_by_semesterentry(semesterentry.id)

    socket
    |> assign(:page_title, "Ermäßigungen")
    |> assign(:semesterentry, semesterentry)
    |> stream(:reduction_entries, reduction_entries, reset: true)
  end

  defp apply_action(socket, :new_reduction, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)
    reduction_types = Reductions.list_reduction_types()
    reduction_entries = Reductions.list_reduction_entries_by_semesterentry(semesterentry.id)

    socket
    |> assign(:page_title, "Neue Ermäßigung")
    |> assign(:semesterentry, semesterentry)
    |> assign(:reduction_types, reduction_types)
    |> assign(:reduction_entry, %Reductions.ReductionEntry{})
    |> stream(:reduction_entries, reduction_entries, reset: true)
  end

  defp apply_action(socket, :edit_reduction, %{"id" => id, "reduction_id" => reduction_id}) do
    reduction_entry = Reductions.get_reduction_entry!(reduction_id)
    semesterentry = Semesterentrys.get_semesterentry!(id)
    reduction_types = Reductions.list_reduction_types()
    reduction_entries = Reductions.list_reduction_entries_by_semesterentry(semesterentry.id)

    socket
    |> assign(:page_title, "Bearbeiten Ermäßigung")
    |> assign(:reduction_entry, reduction_entry)
    |> assign(:semesterentry, semesterentry)
    |> assign(:reduction_types, reduction_types)
    |> stream(:reduction_entries, reduction_entries, reset: true)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Semesterentry")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  defp apply_action(socket, :new_standard_course, %{"id" => id}) do
    standard_course_types = Courses.list_standardcoursetypes()
    standard_course_names = Courses.list_standardcoursenames()
    studygroups = Courses.list_studygroups()

    semesterentry = Semesterentrys.get_semesterentry!(id)

    standard_course_entries =
      Courses.list_standard_course_entries_by_semesterentry(semesterentry.id)

    socket
    |> assign(:page_title, "New Standard Course")
    |> assign(:semesterentry, semesterentry)
    |> assign(:standard_course_types, standard_course_types)
    |> assign(:standard_course_names, standard_course_names)
    |> assign(:studygroups, studygroups)
    |> assign(:standard_course_entry, %StandardCourseEntry{})
    |> stream(:standard_course_entries, standard_course_entries, reset: true)
  end

  defp apply_action(socket, :edit_standard_course, %{"id" => id, "course_id" => course_id}) do
    standard_course_entry = Courses.get_standard_course_entry!(course_id)
    semesterentry = Semesterentrys.get_semesterentry!(id)

    standard_course_entries =
      Courses.list_standard_course_entries_by_semesterentry(semesterentry.id)

    standard_course_types = Courses.list_standardcoursetypes()
    standard_course_names = Courses.list_standardcoursenames()
    studygroups = Courses.list_studygroups()

    socket
    |> assign(:page_title, "Edit Standard Course")
    |> assign(:course_id, course_id)
    |> assign(:semesterentry, semesterentry)
    |> assign(:standard_course_entry, standard_course_entry)
    |> assign(:standard_course_types, standard_course_types)
    |> assign(:standard_course_names, standard_course_names)
    |> assign(:studygroups, studygroups)
    |> stream(:standard_course_entries, standard_course_entries, reset: true)
  end

  defp apply_action(socket, :new_thesis, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)
    thesis_types = Theses.list_thesis_types()
    studygroups = Courses.list_studygroups()

    thesis_entries = Theses.list_theses_entries_by_semesterentry(semesterentry.id)

    socket
    |> assign(:page_title, "Neue Thesis")
    |> assign(:semesterentry, semesterentry)
    |> assign(:thesis_types, thesis_types)
    |> assign(:studygroups, studygroups)
    |> assign(:thesis_entry, %ThesisEntry{})
    |> stream(:thesis_entries, thesis_entries, reset: true)
  end

  defp apply_action(socket, :edit_thesis, %{"id" => id, "thesis_id" => thesis_id}) do
    thesis_entry = Theses.get_thesis_entry!(thesis_id)
    semesterentry = Semesterentrys.get_semesterentry!(id)
    thesis_entries = Theses.list_theses_entries_by_semesterentry(semesterentry.id)

    thesis_types = Theses.list_thesis_types()
    studygroups = Courses.list_studygroups()

    socket
    |> assign(:page_title, "Bearbeiten Thesis")
    |> assign(:thesis_entry, thesis_entry)
    |> assign(:semesterentry, semesterentry)
    |> assign(:thesis_types, thesis_types)
    |> assign(:studygroups, studygroups)
    |> stream(:thesis_entries, thesis_entries, reset: true)
  end

  @impl true
  def handle_info(
        {LvsToolWeb.SemesterentryLive.StandardCoursesComponent, {:deleted_standard_course, id}},
        socket
      ) do
    standard_course_entry = Courses.get_standard_course_entry!(id)

    case Courses.delete_standard_course_entry(standard_course_entry) do
      {:ok, _} ->
        updated_semesterentry = Semesterentrys.recalculate_lvs_sum(socket.assigns.semesterentry)

        standard_course_entries =
          Courses.list_standard_course_entries_by_semesterentry(socket.assigns.semesterentry.id)

        {:noreply,
         socket
         |> assign(:semesterentry, updated_semesterentry)
         |> put_flash(:info, "Standard-Kurs gelöscht")
         |> stream(:standard_course_entries, standard_course_entries, reset: true)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_info(
        {LvsToolWeb.SemesterentryLive.ThesisComponent, {:deleted_thesis, id}},
        socket
      ) do
    thesis_entry = Theses.get_thesis_entry!(id)

    case Theses.delete_thesis_entry(thesis_entry) do
      {:ok, _} ->
        updated_semesterentry =
          socket.assigns.semesterentry
          |> Semesterentrys.recalculate_lvs_sum()
          |> Semesterentrys.update_theses_count()

        thesis_entries =
          Theses.list_theses_entries_by_semesterentry(socket.assigns.semesterentry.id)

        {:noreply,
         socket
         |> assign(:semesterentry, updated_semesterentry)
         |> put_flash(:info, "Thesis gelöscht")
         |> stream(:thesis_entries, thesis_entries, reset: true)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_info(
        {LvsToolWeb.SemesterentryLive.ReductionsComponent, {:deleted_reduction, id}},
        socket
      ) do
    reduction_entry = Reductions.get_reduction_entry!(id)

    case Reductions.delete_reduction_entry(reduction_entry) do
      {:ok, _} ->
        updated_semesterentry = Semesterentrys.recalculate_lvs_sum(socket.assigns.semesterentry)

        reduction_entries =
          Reductions.list_reduction_entries_by_semesterentry(socket.assigns.semesterentry.id)

        {:noreply,
         socket
         |> assign(:semesterentry, updated_semesterentry)
         |> assign(
           :calculated_user_lvs_requirements,
           Accounts.get_user_lvs_requirements_with_reduction_calculation(
             socket.assigns.current_user,
             socket.assigns.semesterentry.id
           )
         )
         |> put_flash(:info, "Ermäßigung gelöscht")
         |> stream(:reduction_entries, reduction_entries, reset: true)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_info(
        {LvsToolWeb.SemesterentryLive.ReductionsFormComponent, :reduction_updated},
        socket
      ) do
    {:noreply,
     socket
     |> assign(
       :calculated_user_lvs_requirements,
       Accounts.get_user_lvs_requirements_with_reduction_calculation(
         socket.assigns.current_user,
         socket.assigns.semesterentry.id
       )
     )}
  end

  @impl true
  def handle_event("submit_for_review", %{"id" => id}, socket) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    case Semesterentrys.update_semesterentry(semesterentry, %{status: "Eingereicht"}) do
      {:ok, _updated_semesterentry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Semestereintrag wurde zur Prüfung eingereicht")
         |> push_navigate(to: ~p"/semesterentrys")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Einreichen")}
    end
  end

  @impl true
  def handle_event("forward_to_presidium", %{"id" => id}, socket) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    case Semesterentrys.forward_to_presidium(semesterentry) do
      {:ok, _updated_semesterentry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Semestereintrag wurde an das Präsidium weitergeleitet")
         |> push_navigate(to: ~p"/semesterentrys")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Weiterleiten")}
    end
  end

  @impl true
  def handle_event("approve_semesterentry", %{"id" => id}, socket) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    case Semesterentrys.approve_semesterentry(semesterentry) do
      {:ok, _updated_semesterentry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Semestereintrag wurde genehmigt")
         |> push_navigate(to: ~p"/semesterentrys")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Genehmigen")}
    end
  end

  @impl true
  def handle_event("reject_semesterentry", %{"id" => id}, socket) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    case Semesterentrys.reject_semesterentry(semesterentry) do
      {:ok, _updated_semesterentry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Semestereintrag wurde abgelehnt")
         |> push_navigate(to: ~p"/semesterentrys")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Ablehnen")}
    end
  end

  # Helper-Funktionen entfernt - Logik ist jetzt direkt im Template
end
