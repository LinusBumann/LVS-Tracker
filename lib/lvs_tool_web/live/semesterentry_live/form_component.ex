defmodule LvsToolWeb.SemesterentryLive.FormComponent do
  use LvsToolWeb, :live_component

  alias LvsTool.Semesterentrys

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage semesterentry records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="semesterentry-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:status]} type="text" label="Status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Semesterentry</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{semesterentry: semesterentry} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Semesterentrys.change_semesterentry(semesterentry))
     end)}
  end

  @impl true
  def handle_event("validate", %{"semesterentry" => semesterentry_params}, socket) do
    changeset =
      Semesterentrys.change_semesterentry(socket.assigns.semesterentry, semesterentry_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"semesterentry" => semesterentry_params}, socket) do
    save_semesterentry(socket, socket.assigns.action, semesterentry_params)
  end

  defp save_semesterentry(socket, :edit, semesterentry_params) do
    case Semesterentrys.update_semesterentry(socket.assigns.semesterentry, semesterentry_params) do
      {:ok, semesterentry} ->
        notify_parent({:saved, semesterentry})

        {:noreply,
         socket
         |> put_flash(:info, "Semesterentry updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_semesterentry(socket, :new, semesterentry_params) do
    semesterentry_params = Map.put(semesterentry_params, "user_id", socket.assigns.user.id)

    case Semesterentrys.create_semesterentry(semesterentry_params) do
      {:ok, semesterentry} ->
        notify_parent({:saved, semesterentry})

        {:noreply,
         socket
         |> put_flash(:info, "Semesterentry created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
