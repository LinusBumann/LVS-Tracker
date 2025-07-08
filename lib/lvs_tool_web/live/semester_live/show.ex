defmodule LvsToolWeb.SemesterLive.Show do
  use LvsToolWeb, :live_view

  alias LvsTool.Lehrdeputat

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:semester, Lehrdeputat.get_semester!(id))}
  end

  defp page_title(:show), do: "Show Semester"
  defp page_title(:edit), do: "Edit Semester"
end
