defmodule LvsToolWeb.SemesterentryLive.ExcursionsComponent do
  use LvsToolWeb, :live_component

  alias Phoenix.LiveView.JS
  alias LvsToolWeb.RoleHelpers
  alias LvsToolWeb.StatusHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <div class="flex justify-between items-center">
        <h2 class="text-xl font-semibold text-gray-900">Exkursionen</h2>
        
    <!-- Button nur für Lehrende anzeigen, wenn Semestereintrag noch nicht eingereicht -->
        <.link
          :if={
            RoleHelpers.is_role?(@user_role, :lehrperson) and
              StatusHelpers.is_editable?(@semesterentry.status)
          }
          patch={~p"/semesterentrys/#{@semesterentry.id}/excursions/new"}
        >
          <.button>
            <span class="flex items-center gap-2">
              <.icon name="hero-plus" class="h-4 w-4" /> Exkursion hinzufügen
            </span>
          </.button>
        </.link>
      </div>
      
      <div :if={Enum.count(@excursion_entries) > 0} class="bg-white shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <div class="flow-root">
            <ul
              role="list"
              phx-update="stream"
              id="excursion-entries-list"
              class="-my-5 divide-y divide-gray-200"
            >
              <li :for={{dom_id, excursion} <- @excursion_entries} id={dom_id} class="py-4">
                <div class="flex items-center space-x-4">
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-gray-900 truncate">
                      {excursion.name}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Studiengruppen:</span> {Enum.map(
                        excursion.studygroups,
                        fn group -> group.name end
                      )}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Anzahl der Studierenden:</span> {excursion.student_count}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Max. Lehreinheiten pro Tag:</span> {excursion.daily_max_teaching_units}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Anrechnungsfaktor:</span> {excursion.imputationfactor}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">LVS:</span> {excursion.lvs}
                    </p>
                  </div>
                  
    <!-- Aktions-Buttons nur für Lehrende anzeigen, wenn Semestereintrag noch nicht eingereicht -->
                  <div
                    :if={
                      RoleHelpers.is_role?(@user_role, :lehrperson) and
                        StatusHelpers.is_editable?(@semesterentry.status)
                    }
                    class="flex items-center space-x-2"
                  >
                    <.link patch={
                      ~p"/semesterentrys/#{@semesterentry.id}/excursions/#{excursion.id}/edit"
                    }>
                      <.button class="text-blue-600 hover:text-blue-900 bg-blue-100 hover:bg-blue-200">
                        <.icon name="hero-pencil-square" class="h-4 w-4" />
                      </.button>
                    </.link>
                    
                    <.button
                      phx-click={
                        JS.push("delete_excursion", target: @myself, value: %{id: excursion.id})
                      }
                      phx-target={@myself}
                      data-confirm="Sind Sie sicher, dass Sie diese Exkursion löschen möchten?"
                      class="text-red-600 hover:text-red-900 bg-red-100 hover:bg-red-200"
                    >
                      <.icon name="hero-trash" class="h-4 w-4" />
                    </.button>
                  </div>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
      
      <div :if={Enum.count(@excursion_entries) == 0} class="text-center py-12">
        <div class="mx-auto h-12 w-12 text-gray-400">
          <.icon name="hero-map" class="h-12 w-12" />
        </div>
        
        <h3 class="mt-2 text-sm font-medium text-gray-900">Keine Exkursionen</h3>
        
        <p class="mt-1 text-sm text-gray-500">
          <%= if RoleHelpers.is_role?(@user_role, :lehrperson) and StatusHelpers.is_editable?(@semesterentry.status) do %>
            Fügen Sie Ihre erste Exkursion hinzu.
          <% else %>
            Keine Exkursionen vorhanden.
          <% end %>
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("delete_excursion", %{"id" => id}, socket) do
    notify_parent({:deleted_excursion, id})
    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
