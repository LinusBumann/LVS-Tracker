defmodule LvsToolWeb.SemesterLive.FormComponent do
  use LvsToolWeb, :live_component

  alias LvsTool.Lehrdeputat

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage semester records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="semester-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Semester</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{semester: semester} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Lehrdeputat.change_semester(semester))
     end)}
  end

  @impl true
  def handle_event("validate", %{"semester" => semester_params}, socket) do
    changeset = Lehrdeputat.change_semester(socket.assigns.semester, semester_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"semester" => semester_params}, socket) do
    semester_params =
      semester_params
      |> Map.put("user_name", socket.assigns.current_user.name)
      |> Map.put("user_id", socket.assigns.current_user.id)

    save_semester(socket, socket.assigns.action, semester_params)
  end

  defp save_semester(socket, :edit, semester_params) do
    case Lehrdeputat.update_semester(socket.assigns.semester, semester_params) do
      {:ok, semester} ->
        notify_parent({:saved, semester})

        {:noreply,
         socket
         |> put_flash(:info, "Semester updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_semester(socket, :new, semester_params) do
    case Lehrdeputat.create_semester(semester_params) do
      {:ok, semester} ->
        notify_parent({:saved, semester})

        {:noreply,
         socket
         |> put_flash(:info, "Semester created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
