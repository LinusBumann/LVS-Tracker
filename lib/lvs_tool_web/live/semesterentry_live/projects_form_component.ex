defmodule LvsToolWeb.SemesterentryLive.ProjectsFormComponent do
  use LvsToolWeb, :live_component

  alias LvsTool.Projects
  alias LvsTool.Semesterentrys

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@page_title}
        <:subtitle>
          Verwenden Sie dieses Formular, um ein Projekt zu erstellen oder zu bearbeiten.
        </:subtitle>
      </.header>
      
      <.simple_form
        for={@form}
        id="project-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Projektname" required />
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
          step="5"
          min="0"
          max="100"
          icon="hero-question-mark-circle-solid"
          tooltip_text="Beispiele: 100% = alleinige Durchführung, 50% = geteilte Veranstaltung"
          required
        /> <.input field={@form[:lvs]} type="number" disabled label="LVS" required />
        <:actions>
          <.button phx-disable-with="Saving...">Projekt speichern</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{project_entry: project_entry} = assigns, socket) do
    attrs =
      case project_entry.id do
        nil ->
          %{"percent" => "100", "student_count" => "8"}

        _ ->
          %{
            "studygroup_ids" => Enum.map(project_entry.studygroups, & &1.id)
          }
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Projects.change_project_entry(project_entry, attrs))
     end)}
  end

  @impl true
  def handle_event("validate", %{"project_entry" => project_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(project_entry_params)

    changeset =
      Projects.change_project_entry(
        socket.assigns.project_entry,
        params_with_lvs
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"project_entry" => project_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(project_entry_params)
    save_project_entry(socket, socket.assigns.live_action, params_with_lvs)
  end

  defp save_project_entry(socket, :edit_project, project_entry_params) do
    case Projects.update_project_entry(
           socket.assigns.project_entry,
           project_entry_params
         ) do
      {:ok, _project_entry} ->
        # LVS-Summe neu berechnen
        Semesterentrys.recalculate_lvs_sum(socket.assigns.semesterentry)

        {:noreply,
         socket
         |> put_flash(:info, "Projekt aktualisiert")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_project_entry(socket, :new_project, project_entry_params) do
    project_entry_params =
      Map.put(project_entry_params, "semesterentry_id", socket.assigns.semesterentry.id)

    case Projects.create_project_entry(project_entry_params) do
      {:ok, _project_entry} ->
        # LVS-Summe neu berechnen
        Semesterentrys.recalculate_lvs_sum(socket.assigns.semesterentry)

        {:noreply,
         socket
         |> put_flash(:info, "Projekt erstellt")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp add_lvs_to_params(project_entry_params) do
    if project_entry_params["percent"] != "" &&
         project_entry_params["sws"] != "" &&
         project_entry_params["student_count"] != "" do
      lvs =
        Projects.calculate_project_lvs(
          project_entry_params["sws"],
          project_entry_params["percent"],
          project_entry_params["student_count"]
        )

      Map.put(project_entry_params, "lvs", lvs)
    else
      project_entry_params
    end
  end
end
