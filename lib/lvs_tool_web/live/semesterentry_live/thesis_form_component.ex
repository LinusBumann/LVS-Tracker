defmodule LvsToolWeb.SemesterentryLive.ThesisFormComponent do
  use LvsToolWeb, :live_component

  alias LvsTool.Theses
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
      
      <.simple_form
        for={@form}
        id="thesis-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:thesis_title]} type="text" label="Thesistitel" required />
        <.input
          field={@form[:thesis_type_id]}
          type="select"
          label="Thesistyp"
          options={Enum.map(@thesis_types, &{&1.name, &1.id})}
          required
        />
        <.input
          field={@form[:studygroup_ids]}
          type="select"
          label="Studiengruppen"
          options={Enum.map(@studygroups, &{&1.name, &1.id})}
          required
        /> <.input field={@form[:lvs]} type="number" disabled label="LVS" step="0.1" required />
        <:actions>
          <.button phx-disable-with="Saving...">Semestereintrag speichern</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{thesis_entry: thesis_entry} = assigns, socket) do
    attrs =
      case thesis_entry.id do
        nil ->
          %{}

        _ ->
          %{
            "thesis_type_id" => thesis_entry.thesis_type_id,
            "studygroup_ids" => Enum.map(thesis_entry.studygroups, & &1.id)
          }
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn -> to_form(Theses.change_thesis_entry(thesis_entry, attrs)) end)}
  end

  @impl true
  def handle_event("validate", %{"thesis_entry" => thesis_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(thesis_entry_params)

    changeset =
      Theses.change_thesis_entry(
        socket.assigns.thesis_entry,
        params_with_lvs
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"thesis_entry" => thesis_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(thesis_entry_params)
    save_thesis_entry(socket, socket.assigns.live_action, params_with_lvs)
  end

  defp save_thesis_entry(socket, :edit_thesis, thesis_entry_params) do
    case Theses.update_thesis_entry(
           socket.assigns.thesis_entry,
           thesis_entry_params
         ) do
      {:ok, _thesis_entry} ->
        # LVS-Summe neu berechnen
        Semesterentrys.recalculate_lvs_sum(socket.assigns.semesterentry)

        {:noreply,
         socket
         |> put_flash(:info, "Thesis aktualisiert")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_thesis_entry(socket, :new_thesis, thesis_entry_params) do
    thesis_entry_params =
      Map.put(thesis_entry_params, "semesterentry_id", socket.assigns.semesterentry.id)

    case Theses.create_thesis_entry(thesis_entry_params) do
      {:ok, _thesis_entry} ->
        socket.assigns.semesterentry
        |> Semesterentrys.recalculate_lvs_sum()
        |> Semesterentrys.update_theses_count()

        {:noreply,
         socket
         |> put_flash(:info, "Thesis erstellt")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp add_lvs_to_params(thesis_entry_params) do
    lvs =
      Theses.calculate_thesis_lvs(thesis_entry_params["thesis_type_id"])

    Map.put(thesis_entry_params, "lvs", lvs)
  end
end
