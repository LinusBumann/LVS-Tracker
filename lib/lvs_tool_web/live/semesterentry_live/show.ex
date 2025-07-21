defmodule LvsToolWeb.SemesterentryLive.Show do
  use LvsToolWeb, :live_view

  alias LvsTool.Semesterentrys
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
    socket
    |> assign(:page_title, "Show Semesterentry")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Semesterentry")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  defp apply_action(socket, :new_standard_course, %{"id" => id}) do
    socket
    |> assign(:page_title, "New Standard Course")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  defp apply_action(socket, :edit_standard_course, %{"id" => id, "course_id" => course_id}) do
    socket
    |> assign(:page_title, "Edit Standard Course")
    |> assign(:course_id, course_id)
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  @impl true
  def handle_info(
        {LvsToolWeb.SemesterentryLive.StandardCoursesComponent,
         {:deleted_standard_course, updated_semesterentry}},
        socket
      ) do
    {:noreply, assign(socket, :semesterentry, updated_semesterentry)}
  end

  @impl true
  def handle_event("switch_tab", %{"tab_id" => tab_id}, socket) do
    {:noreply, assign(socket, active_tab: tab_id)}
  end
end
