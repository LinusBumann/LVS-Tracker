defmodule LvsToolWeb.SemesterentryLive.Show do
  use LvsToolWeb, :live_view

  alias LvsTool.Semesterentrys

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))}
  end

  defp page_title(:show), do: "Show Semesterentry"
  defp page_title(:edit), do: "Edit Semesterentry"
end
