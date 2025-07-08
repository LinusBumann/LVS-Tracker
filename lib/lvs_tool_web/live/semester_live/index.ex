defmodule LvsToolWeb.SemesterLive.Index do
  use LvsToolWeb, :live_view

  alias LvsTool.Lehrdeputat
  alias LvsTool.Lehrdeputat.Semester

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    socket = assign(socket, :current_user, user)
    {:ok, stream(socket, :semesters, Lehrdeputat.list_semesters_by_user(user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Semester")
    |> assign(:semester, Lehrdeputat.get_semester!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Semester")
    |> assign(:semester, %Semester{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Semesters")
    |> assign(:semester, nil)
  end

  @impl true
  def handle_info({LvsToolWeb.SemesterLive.FormComponent, {:saved, semester}}, socket) do
    {:noreply, stream_insert(socket, :semesters, semester)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    semester = Lehrdeputat.get_semester!(id)
    {:ok, _} = Lehrdeputat.delete_semester(semester)

    {:noreply, stream_delete(socket, :semesters, semester)}
  end
end
