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
          Verwenden Sie dieses Formular, um eine Ermäßigung zu erstellen oder zu bearbeiten.
        </:subtitle>
      </.header>
      
      <.simple_form
        for={@form}
        id="reduction-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:reduction_type_id]}
          type="select"
          label="Ermäßigungstyp"
          options={Enum.map(@reduction_types, &{&1.reduction_reason, &1.id})}
        /> <.input field={@form[:lvs]} type="number" label="LVS" step="0.5" min="0" disabled />
        <:actions>
          <.button phx-disable-with="Speichern...">Speichern</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{reduction_entry: reduction_entry} = assigns, socket) do
    attrs =
      case reduction_entry.id do
        nil ->
          %{}

        _ ->
          %{
            "reduction_type_id" => reduction_entry.reduction_type_id
          }
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Reductions.change_reduction_entry(reduction_entry, attrs))
     end)}
  end

  @impl true
  def handle_event("validate", %{"reduction_entry" => reduction_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(reduction_entry_params)

    changeset =
      Reductions.change_reduction_entry(
        socket.assigns.reduction_entry,
        params_with_lvs
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"reduction_entry" => reduction_entry_params}, socket) do
    params_with_lvs = add_lvs_to_params(reduction_entry_params)
    save_reduction_entry(socket, socket.assigns.live_action, params_with_lvs)
  end

  defp save_reduction_entry(socket, :edit_reduction, reduction_entry_params) do
    case Reductions.update_reduction_entry(
           socket.assigns.reduction_entry,
           reduction_entry_params
         ) do
      {:ok, _reduction_entry} ->
        # LVS-Summe neu berechnen
        Semesterentrys.recalculate_lvs_sum(socket.assigns.semesterentry)

        {:noreply,
         socket
         |> put_flash(:info, "Ermäßigung erfolgreich aktualisiert")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_reduction_entry(socket, :new_reduction, reduction_entry_params) do
    reduction_entry_params =
      Map.put(reduction_entry_params, "semesterentry_id", socket.assigns.semesterentry.id)

    case Reductions.create_reduction_entry(reduction_entry_params) do
      {:ok, _reduction_entry} ->
        socket.assigns.semesterentry
        |> Semesterentrys.recalculate_lvs_sum()

        {:noreply,
         socket
         |> put_flash(:info, "Ermäßigung erfolgreich erstellt")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp add_lvs_to_params(reduction_entry_params) do
    if reduction_entry_params["reduction_type_id"] != "" do
      reduction_type = Reductions.get_reduction!(reduction_entry_params["reduction_type_id"])

      if reduction_type.reduction_lvs do
        Map.put(reduction_entry_params, "lvs", reduction_type.reduction_lvs)
      else
        reduction_entry_params
      end
    else
      reduction_entry_params
    end
  end
end
