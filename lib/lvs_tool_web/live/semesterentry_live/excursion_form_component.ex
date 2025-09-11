defmodule LvsToolWeb.SemesterentryLive.ExcursionFormComponent do
  use LvsToolWeb, :live_component

  alias LvsTool.Excursions
  alias LvsTool.Semesterentrys

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@page_title}
        <:subtitle>
          Verwenden Sie dieses Formular, um eine Exkursion zu erstellen oder zu bearbeiten.
        </:subtitle>
      </.header>
      
      <.simple_form
        for={@form}
        id="excursion-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Exkursionsname" required />
        <.input
          field={@form[:studygroup_ids]}
          type="select"
          label="Studiengruppen"
          options={Enum.map(@studygroups, &{&1.name, &1.id})}
          required
        />
        <.input
          field={@form[:student_count]}
          type="number"
          label="Anzahl der Studierenden"
          min="1"
          required
        />
        <.input
          field={@form[:daily_max_teaching_units]}
          type="number"
          label="Maximale Lehreinheiten pro Tag"
          min="1"
          max="12"
          step="1"
          required
        />
        <.input
          field={@form[:lvs]}
          type="number"
          step="0.1"
          disabled
          label="LVS (wird automatisch berechnet)"
          required
        />
        <:actions>
          <.button phx-disable-with="Speichern...">Exkursion speichern</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{excursion_entry: excursion_entry} = assigns, socket) do
    attrs =
      case excursion_entry.id do
        nil ->
          %{"imputationfactor" => 0.3}

        _ ->
          %{
            "studygroup_ids" => Enum.map(excursion_entry.studygroups, & &1.id)
          }
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Excursions.change_excursion_entry(excursion_entry, attrs))
     end)}
  end

  @impl true
  def handle_event("validate", %{"excursion_entry" => excursion_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(excursion_entry_params)

    changeset =
      Excursions.change_excursion_entry(
        socket.assigns.excursion_entry,
        params_with_lvs
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"excursion_entry" => excursion_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(excursion_entry_params)
    save_excursion_entry(socket, socket.assigns.live_action, params_with_lvs)
  end

  defp save_excursion_entry(socket, :edit_excursion, excursion_entry_params) do
    case Excursions.update_excursion_entry(
           socket.assigns.excursion_entry,
           excursion_entry_params
         ) do
      {:ok, _excursion_entry} ->
        # LVS-Summe neu berechnen
        Semesterentrys.recalculate_lvs_sum(socket.assigns.semesterentry)

        {:noreply,
         socket
         |> put_flash(:info, "Exkursion aktualisiert")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_excursion_entry(socket, :new_excursion, excursion_entry_params) do
    excursion_entry_params =
      Map.put(excursion_entry_params, "semesterentry_id", socket.assigns.semesterentry.id)

    case Excursions.create_excursion_entry(excursion_entry_params) do
      {:ok, _excursion_entry} ->
        # LVS-Summe neu berechnen
        Semesterentrys.recalculate_lvs_sum(socket.assigns.semesterentry)

        {:noreply,
         socket
         |> put_flash(:info, "Exkursion erstellt")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp add_lvs_to_params(excursion_entry_params) do
    # Anrechnungsfaktor ist immer 0.3
    imputationfactor = 0.3
    params_with_factor = Map.put(excursion_entry_params, "imputationfactor", imputationfactor)

    if params_with_factor["daily_max_teaching_units"] != "" do
      daily_max_teaching_units = String.to_integer(params_with_factor["daily_max_teaching_units"])

      lvs = Excursions.calculate_excursion_lvs(daily_max_teaching_units, imputationfactor)

      Map.put(params_with_factor, "lvs", lvs)
    else
      params_with_factor
    end
  end
end
