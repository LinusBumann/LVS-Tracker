defmodule LvsToolWeb.SemesterentryLive.ReductionsFormComponent do
  use LvsToolWeb, :live_component

  alias LvsTool.Reductions
  alias LvsTool.Semesterentrys

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@page_title}
        <:subtitle>
          Verwenden Sie dieses Formular, um eine Thesis zu erstellen oder zu bearbeiten.
        </:subtitle>
      </.header>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("delete_reduction", %{"id" => id}, socket) do
    notify_parent({:deleted_reduction, id})
    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
