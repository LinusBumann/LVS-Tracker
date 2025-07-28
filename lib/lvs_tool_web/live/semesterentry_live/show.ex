defmodule LvsToolWeb.SemesterentryLive.Show do
  use LvsToolWeb, :live_view

  alias LvsTool.Semesterentrys
  alias Phoenix.LiveView.JS
  alias LvsTool.Courses
  alias LvsTool.Courses.StandardCourseEntry
  alias LvsTool.Theses
  alias LvsTool.Theses.ThesisEntry

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:active_tab, "standard-courses")
     |> stream(:standard_course_entries, [], reset: true)
     |> stream(:thesis_entries, [], reset: true)}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

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

    socket
    |> assign(:page_title, "New Standard Course")
    |> assign(:semesterentry, semesterentry)
    |> assign(:standard_course_types, standard_course_types)
    |> assign(:standard_course_names, standard_course_names)
    |> assign(:studygroups, studygroups)
    |> assign(:standard_course_entry, %StandardCourseEntry{})
  end

  defp apply_action(socket, :edit_standard_course, %{"id" => id, "course_id" => course_id}) do
    standard_course_entry = Courses.get_standard_course_entry!(course_id)
    semesterentry = Semesterentrys.get_semesterentry!(id)

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
  end

  defp apply_action(socket, :new_thesis, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)
    thesis_types = Theses.list_thesis_types()
    studygroups = Courses.list_studygroups()

    socket
    |> assign(:page_title, "Neue Thesis")
    |> assign(:semesterentry, semesterentry)
    |> assign(:thesis_types, thesis_types)
    |> assign(:studygroups, studygroups)
    |> assign(:thesis_entry, %ThesisEntry{})
  end

  defp apply_action(socket, :edit_thesis, %{"id" => id, "thesis_id" => thesis_id}) do
    thesis_entry = Theses.get_thesis_entry!(thesis_id)
    semesterentry = Semesterentrys.get_semesterentry!(id)

    thesis_types = Theses.list_thesis_types()
    studygroups = Courses.list_studygroups()

    socket
    |> assign(:page_title, "Bearbeiten Thesis")
    |> assign(:thesis_entry, thesis_entry)
    |> assign(:semesterentry, semesterentry)
    |> assign(:thesis_types, thesis_types)
    |> assign(:studygroups, studygroups)
  end

  @impl true
  def handle_info(
        {LvsToolWeb.SemesterentryLive.StandardCoursesComponent, {:deleted_standard_course, id}},
        socket
      ) do
    standard_course_entry = Courses.get_standard_course_entry!(id)

    case Courses.delete_standard_course_entry(standard_course_entry) do
      {:ok, _} ->
        # LVS-Summe neu berechnen
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
        # LVS-Summe neu berechnen
        updated_semesterentry = Semesterentrys.recalculate_lvs_sum(socket.assigns.semesterentry)

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

  @impl true
  def handle_event("switch_tab", %{"tab_id" => tab_id}, socket) do
    socket =
      case tab_id do
        "standard-courses" ->
          # Lade Standard-Kurs Daten neu, wenn zu diesem Tab gewechselt wird
          standard_course_entries =
            Courses.list_standard_course_entries_by_semesterentry(socket.assigns.semesterentry.id)

          socket
          |> stream(:standard_course_entries, standard_course_entries, reset: true)

        "thesis" ->
          thesis_entries =
            Theses.list_theses_entries_by_semesterentry(socket.assigns.semesterentry.id)

          socket
          |> stream(:thesis_entries, thesis_entries, reset: true)

        _ ->
          socket
      end

    {:noreply, assign(socket, active_tab: tab_id)}
  end
end
