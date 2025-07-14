defmodule LvsToolWeb.SemesterentryLive.Show do
  use LvsToolWeb, :live_view

  alias LvsTool.Semesterentrys
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, active_tab: "standard-courses")}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
     |> assign(:course_id, params["course_id"])
     |> assign(:project_id, params["project_id"])
     |> assign(:excursion_id, params["excursion_id"])
     |> assign(:thesis_id, params["thesis_id"])
     |> assign(:reduction_id, params["reduction_id"])}
  end

  @impl true
  def handle_event("switch_tab", %{"tab_id" => tab_id}, socket) do
    {:noreply, assign(socket, active_tab: tab_id)}
  end

  defp page_title(:show), do: "Show Semesterentry"
  defp page_title(:edit), do: "Edit Semesterentry"
  defp page_title(:new_standard_course), do: "Neuer Standard-Kurs"
  defp page_title(:edit_standard_course), do: "Standard-Kurs bearbeiten"
  defp page_title(:new_project), do: "Neues Projekt"
  defp page_title(:edit_project), do: "Projekt bearbeiten"
  defp page_title(:new_excursion), do: "Neue Exkursion"
  defp page_title(:edit_excursion), do: "Exkursion bearbeiten"
  defp page_title(:new_thesis), do: "Neue Thesis"
  defp page_title(:edit_thesis), do: "Thesis bearbeiten"
  defp page_title(:new_reduction), do: "Neue Ermäßigung"
  defp page_title(:edit_reduction), do: "Ermäßigung bearbeiten"
end
