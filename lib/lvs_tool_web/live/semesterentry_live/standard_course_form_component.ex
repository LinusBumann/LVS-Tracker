defmodule LvsToolWeb.SemesterentryLive.StandardCourseFormComponent do
  use LvsToolWeb, :live_component

  alias LvsTool.Courses
  alias LvsTool.Semesterentrys

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@page_title}
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
          field={@form[:studygroup_ids]}
          type="select"
          label="Studiengruppen"
          options={Enum.map(@studygroups, &{&1.name, &1.id})}
          required
        />
        <.input
          field={@form[:kind]}
          type="select"
          label="Art"
          options={["Pflicht", "Wahlpflicht", "Wahl"]}
          required
        /> <.input field={@form[:student_count]} type="number" label="Teilnehmerzahl" required />
        <.input field={@form[:sws]} type="number" label="SWS" required />
        <.input
          field={@form[:percent]}
          type="number"
          label="Anteil an der Veranstaltung (in %)"
          required
        /> <.input field={@form[:lvs]} type="number" disabled label="LVS" required />
        <:actions>
          <.button phx-disable-with="Saving...">Semestereintrag speichern</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{standard_course_entry: standard_course_entry} = assigns, socket) do
    attrs =
      case standard_course_entry.id do
        nil ->
          %{}

        _ ->
          %{
            "standardcoursetype_ids" =>
              Enum.map(standard_course_entry.standardcoursetypes, & &1.id),
            "studygroup_ids" => Enum.map(standard_course_entry.studygroups, & &1.id)
          }
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Courses.change_standard_course_entry(standard_course_entry, attrs))
     end)}
  end

  @impl true
  def handle_event("validate", %{"standard_course_entry" => standard_course_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(standard_course_entry_params)

    changeset =
      Courses.change_standard_course_entry(
        socket.assigns.standard_course_entry,
        params_with_lvs
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"standard_course_entry" => standard_course_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(standard_course_entry_params)
    save_standard_course_entry(socket, socket.assigns.live_action, params_with_lvs)
  end

  defp save_standard_course_entry(socket, :edit_standard_course, standard_course_entry_params) do
    old_lvs = socket.assigns.standard_course_entry.lvs

    case Courses.update_standard_course_entry(
           socket.assigns.standard_course_entry,
           standard_course_entry_params
         ) do
      {:ok, standard_course_entry} ->
        updated_lvs_sum = standard_course_entry.lvs - old_lvs
        Semesterentrys.update_semesterentry_lvs(socket.assigns.semesterentry, updated_lvs_sum)

        {:noreply,
         socket
         |> put_flash(:info, "Standard-Kurs aktualisiert")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_standard_course_entry(socket, :new_standard_course, standard_course_entry_params) do
    standard_course_entry_params =
      Map.put(standard_course_entry_params, "semesterentry_id", socket.assigns.semesterentry.id)

    case Courses.create_standard_course_entry(standard_course_entry_params) do
      {:ok, standard_course_entry} ->
        Semesterentrys.update_semesterentry_lvs(
          socket.assigns.semesterentry,
          standard_course_entry.lvs
        )

        {:noreply,
         socket
         |> put_flash(:info, "Standard-Kurs erstellt")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp add_lvs_to_params(standard_course_entry_params) do
    if standard_course_entry_params["percent"] != "" &&
         standard_course_entry_params["sws"] != "" do
      lvs =
        Courses.calculate_lvs(
          standard_course_entry_params["sws"],
          standard_course_entry_params["percent"],
          standard_course_entry_params["standardcoursetype_ids"]
        )

      Map.put(standard_course_entry_params, "lvs", lvs)
    else
      standard_course_entry_params
    end
  end
end
