defmodule LvsToolWeb.SemesterentryLive.ThesisComponent do
  use LvsToolWeb, :live_component

  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <div class="flex justify-between items-center">
        <h2 class="text-xl font-semibold text-gray-900">Thesis</h2>
        
        <.link patch={~p"/semesterentrys/#{@semesterentry.id}/thesis/new"}>
          <.button>
            <span class="flex items-center gap-2">
              <.icon name="hero-plus" class="h-4 w-4" /> Thesis hinzufügen
            </span>
          </.button>
        </.link>
      </div>
      
      <div :if={Enum.count(@thesis_entries) == 0} class="text-center py-12">
        <div class="mx-auto h-12 w-12 text-gray-400">
          <.icon name="hero-academic-cap" class="h-12 w-12" />
        </div>
        
        <h3 class="mt-2 text-sm font-medium text-gray-900">Keine Thesis</h3>
        
        <p class="mt-1 text-sm text-gray-500">
          Fügen Sie Ihre erste Thesis hinzu.
        </p>
      </div>
      
      <div :if={Enum.count(@thesis_entries) > 0} class="bg-white shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <div class="flow-root">
            <ul
              role="list"
              phx-update="stream"
              id="thesis-entries-list"
              class="-my-5 divide-y divide-gray-200"
            >
              <li :for={{dom_id, thesis} <- @thesis_entries} id={dom_id} class="py-4">
                <div class="flex items-center space-x-4">
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-gray-900 truncate">
                      {thesis.thesis_title}
                    </p>
                    
                    <p class="text-sm font-medium text-gray-500 truncate">
                      Thesistyp: {thesis.thesis_type.name}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Studiengruppen:</span> {Enum.map(
                        thesis.studygroups,
                        fn type -> type.name end
                      )}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Prozentualer Anteil:</span> {thesis.percent}%
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">LVS:</span> {thesis.lvs}
                    </p>
                  </div>
                  
                  <div class="flex items-center space-x-2">
                    <.link patch={~p"/semesterentrys/#{@semesterentry.id}/thesis/#{thesis.id}/edit"}>
                      <.button class="text-blue-600 hover:text-blue-900">
                        <.icon name="hero-pencil-square" class="h-4 w-4" />
                      </.button>
                    </.link>
                    
                    <.button
                      phx-click={JS.push("delete_thesis", target: @myself, value: %{id: thesis.id})}
                      phx-target={@myself}
                      data-confirm="Sind Sie sicher, dass Sie diese Thesis löschen möchten?"
                      class="text-red-600 hover:text-red-900"
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
  def handle_event("delete_thesis", %{"id" => id}, socket) do
    notify_parent({:deleted_thesis, id})
    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
