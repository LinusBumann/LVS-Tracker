defmodule LvsToolWeb.SemesterentryLive.Index do
  use LvsToolWeb, :live_view

  alias LvsTool.Semesterentrys
  alias LvsTool.Semesterentrys.Semesterentry
  alias LvsTool.Accounts
  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    user_role = Accounts.get_user_role(current_user)

    semesterentries =
      Semesterentrys.list_visible_semesterentrys_for_role(
        user_role.id,
        current_user.id
      )

    IO.inspect(semesterentries, label: "semesterentries")

    {:ok,
     socket
     |> assign(:user_role, user_role)
     |> stream(
       :semesterentrys,
       semesterentries
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Semesterentry")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Semesterentry")
    |> assign(:semesterentry, %Semesterentry{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Semesterentrys")
    |> assign(:semesterentry, nil)
  end

  @impl true
  def handle_info({LvsToolWeb.SemesterentryLive.FormComponent, {:saved, semesterentry}}, socket) do
    {:noreply, stream_insert(socket, :semesterentrys, semesterentry)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    semesterentry = Semesterentrys.get_semesterentry!(id)
    {:ok, _} = Semesterentrys.delete_semesterentry(semesterentry)

    {:noreply, stream_delete(socket, :semesterentrys, semesterentry)}
  end
end
