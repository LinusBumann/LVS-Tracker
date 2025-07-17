defmodule LvsToolWeb.SemesterentryLive.Show do
  use LvsToolWeb, :live_view

  alias LvsTool.Semesterentrys
  alias LvsTool.Courses.StandardCourseEntry
  alias LvsTool.Courses
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:active_tab, "standard-courses")}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    socket
    |> assign(:page_title, "Show Semesterentry")
    |> stream(:standard_course_entries, semesterentry.standard_course_entries, reset: true)
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

    socket
    |> assign(:page_title, "New Standard Course")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
    |> assign(:standard_course_entry, %StandardCourseEntry{})
    |> assign(:standard_course_types, standard_course_types)
    |> assign(:standard_course_names, standard_course_names)
    |> assign(:studygroups, studygroups)
  end

  defp apply_action(socket, :edit_standard_course, %{"id" => id, "course_id" => course_id}) do
    semesterentry = Semesterentrys.get_semesterentry!(id)
    standard_course_entry = Courses.get_standard_course_entry!(course_id)
    standard_course_types = Courses.list_standardcoursetypes()
    standard_course_names = Courses.list_standardcoursenames()
    studygroups = Courses.list_studygroups()

    socket
    |> assign(:page_title, "Edit Standard Course")
    |> assign(:semesterentry, semesterentry)
    |> assign(:standard_course_entry, standard_course_entry)
    |> assign(:standard_course_types, standard_course_types)
    |> assign(:standard_course_names, standard_course_names)
    |> assign(:studygroups, studygroups)
  end

  @impl true
  def handle_info(
        {LvsToolWeb.SemesterentryLive.StandardCourseFormComponent,
         {:saved, standard_course_entry}},
        socket
      ) do
    {:noreply, stream_insert(socket, :standard_course_entries, standard_course_entry)}
  end

  @impl true
  def handle_info(
        {LvsToolWeb.SemesterentryLive.StandardCoursesComponent,
         {:deleted_standard_course, standard_course_entry}},
        socket
      ) do
    IO.inspect("handle_info deleted_standard_course")
    {:noreply, stream_delete(socket, :standard_course_entries, standard_course_entry)}
  end

  @impl true
  def handle_event("switch_tab", %{"tab_id" => tab_id}, socket) do
    socket =
      case tab_id do
        "standard-courses" ->
          semesterentry = socket.assigns.semesterentry

          stream(socket, :standard_course_entries, semesterentry.standard_course_entries,
            reset: true
          )

        "projekte" ->
          # stream(socket, :projects, ...)
          socket

        # weitere Tabs...
        _ ->
          socket
      end

    {:noreply, assign(socket, active_tab: tab_id)}
  end

  """
  defp page_title(:new_project), do: "Neues Projekt"
  defp page_title(:edit_project), do: "Projekt bearbeiten"
  defp page_title(:new_excursion), do: "Neue Exkursion"
  defp page_title(:edit_excursion), do: "Exkursion bearbeiten"
  defp page_title(:new_thesis), do: "Neue Thesis"
  defp page_title(:edit_thesis), do: "Thesis bearbeiten"
  defp page_title(:new_reduction), do: "Neue Ermäßigung"
  defp page_title(:edit_reduction), do: "Ermäßigung bearbeiten"
  """
end
