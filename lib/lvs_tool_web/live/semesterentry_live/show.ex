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

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:standard_course_entries, [], reset: true)
     |> stream(:thesis_entries, [], reset: true)
     |> assign(
       :user_lvs_requirements,
       Accounts.get_user_lvs_requirements(socket.assigns.current_user)
     )
     |> IO.inspect()}
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

    socket
    |> assign(:page_title, "Ermäßigungen")
    |> assign(:semesterentry, semesterentry)
  end

  defp apply_action(socket, :new_reduction, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)
    reduction_types = Reductions.list_reduction_types()

    socket
    |> assign(:page_title, "Neue Ermäßigung")
    |> assign(:semesterentry, semesterentry)
    |> assign(:reduction_types, reduction_types)
  end

  defp apply_action(socket, :edit_reduction, %{"id" => id, "reduction_id" => reduction_id}) do
    reduction_type = Reductions.get_reduction!(reduction_id)
    semesterentry = Semesterentrys.get_semesterentry!(id)

    socket
    |> assign(:page_title, "Bearbeiten Ermäßigung")
    |> assign(:reduction_type, reduction_type)
    |> assign(:semesterentry, semesterentry)
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
end
