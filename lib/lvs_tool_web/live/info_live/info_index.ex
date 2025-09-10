defmodule LvsToolWeb.InfoLive.InfoIndex do
  use LvsToolWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :info_index, _params) do
    socket
    |> assign(:page_title, "Allgemeine Infos")
  end

  defp apply_action(socket, :show_pdf, %{"file" => file}) do
    socket
    |> assign(:page_title, "PDF")
    |> assign(:pdf_file, "/pdf/#{file}")
  end
end
