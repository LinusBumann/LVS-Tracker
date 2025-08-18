defmodule LvsToolWeb.SemesterentryLive.Index do
  use LvsToolWeb, :live_view

  alias LvsTool.Semesterentrys
  alias LvsTool.Semesterentrys.Semesterentry
  alias LvsTool.Accounts
  alias LvsToolWeb.RoleHelpers
  alias LvsToolWeb.StatusHelpers

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    user_role = Accounts.get_user_role(current_user)

    semesterentries =
      Semesterentrys.list_visible_semesterentrys_for_role(
        user_role.id,
        current_user.id
      )

    {:ok,
     socket
     |> assign(:user_role, user_role)
     |> assign(:status_helpers, StatusHelpers)
     |> assign(:role_helpers, RoleHelpers)
     |> stream(
       :semesterentries,
       semesterentries
     )
     |> IO.inspect()}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Semestereintrag bearbeiten")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Neuer Semestereintrag")
    |> assign(:semesterentry, %Semesterentry{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Semestereinträge")
    |> assign(:semesterentry, nil)
  end

  defp apply_action(socket, :forward, %{"id" => id}) do
    socket
    |> assign(:page_title, "An Präsidium weiterleiten")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  defp apply_action(socket, :approve, %{"id" => id}) do
    socket
    |> assign(:page_title, "Semestereintrag genehmigen")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  defp apply_action(socket, :reject, %{"id" => id}) do
    socket
    |> assign(:page_title, "Semestereintrag ablehnen")
    |> assign(:semesterentry, Semesterentrys.get_semesterentry!(id))
  end

  @impl true
  def handle_info({LvsToolWeb.SemesterentryLive.FormComponent, {:saved, semesterentry}}, socket) do
    {:noreply, stream_insert(socket, :semesterentries, semesterentry)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    semesterentry = Semesterentrys.get_semesterentry!(id)
    {:ok, _} = Semesterentrys.delete_semesterentry(semesterentry)

    {:noreply, stream_delete(socket, :semesterentries, semesterentry)}
  end

  @impl true
  def handle_event("forward_to_presidium", %{"id" => id}, socket) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    case Semesterentrys.forward_to_presidium(semesterentry) do
      {:ok, updated_semesterentry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Semestereintrag wurde an das Präsidium weitergeleitet")
         |> stream_insert(:semesterentries, updated_semesterentry)
         |> push_patch(to: ~p"/semesterentrys")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Weiterleiten")}
    end
  end

  @impl true
  def handle_event("approve_semesterentry", %{"id" => id}, socket) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    case Semesterentrys.approve_semesterentry(semesterentry) do
      {:ok, updated_semesterentry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Semestereintrag wurde genehmigt")
         |> stream_insert(:semesterentries, updated_semesterentry)
         |> push_patch(to: ~p"/semesterentrys")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Genehmigen")}
    end
  end

  @impl true
  def handle_event("reject_semesterentry", %{"id" => id}, socket) do
    semesterentry = Semesterentrys.get_semesterentry!(id)

    case Semesterentrys.reject_semesterentry(semesterentry) do
      {:ok, _updated_semesterentry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Semestereintrag wurde abgelehnt")
         |> stream_delete(:semesterentries, semesterentry)
         |> push_patch(to: ~p"/semesterentrys")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Ablehnen")}
    end
  end
end
