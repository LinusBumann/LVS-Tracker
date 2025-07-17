defmodule LvsToolWeb.SemesterentryLive.StandardCourseFormComponent do
  use LvsToolWeb, :live_component

  alias LvsTool.Courses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>
          Verwenden Sie dieses Formular, um einen Standard-Kurs zu erstellen oder zu bearbeiten.
        </:subtitle>
      </.header>
      
      <.simple_form
        for={@form}
        id="standard-course-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:standardcoursename_id]}
          type="select"
          label="Kursname"
          options={Enum.map(@standard_course_names, &{&1.name, &1.id})}
          required
        />
        <.input
          field={@form[:standardcoursetype_ids]}
          type="select"
          label="Kurstypen"
          options={Enum.map(@standard_course_types, &{&1.name, &1.id})}
          required
        />
        <.input
          field={@form[:kind]}
          type="select"
          label="Art"
          options={["Pflicht", "Wahlpflicht", "Wahl"]}
          required
        /> <.input field={@form[:sws]} type="number" label="SWS" required />
        <.input field={@form[:student_count]} type="number" label="Teilnehmerzahl" required />
        <.input field={@form[:percent]} type="number" label="Anteil an der Veranstaltung" required />
        <.input field={@form[:lvs]} type="number" label="LVS" required />
        <:actions>
          <.button phx-disable-with="Saving...">Semestereintrag speichern</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{standard_course_entry: standard_course_entry} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Courses.change_standard_course_entry(standard_course_entry))
     end)}
  end

  @impl true
  def handle_event("validate", %{"standard_course_entry" => standard_course_entry_params}, socket) do
    changeset =
      Courses.change_standard_course_entry(
        socket.assigns.standard_course_entry,
        standard_course_entry_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"standard_course_entry" => standard_course_entry_params}, socket) do
    save_standard_course_entry(socket, socket.assigns.action, standard_course_entry_params)
  end

  defp save_standard_course_entry(socket, :edit, standard_course_entry_params) do
    case Courses.update_standard_course_entry(
           socket.assigns.standard_course_entry,
           standard_course_entry_params
         ) do
      {:ok, standard_course_entry} ->
        notify_parent({:saved, standard_course_entry})

        {:noreply,
         socket
         |> put_flash(:info, "Standard-Kurs aktualisiert")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_standard_course_entry(socket, :new, standard_course_entry_params) do
    case Courses.create_standard_course_entry(standard_course_entry_params) do
      {:ok, standard_course_entry} ->
        notify_parent({:saved, standard_course_entry})

        {:noreply,
         socket
         |> put_flash(:info, "Standard-Kurs erstellt")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
