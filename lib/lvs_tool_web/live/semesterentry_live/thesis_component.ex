defmodule LvsToolWeb.SemesterentryLive.ThesisComponent do
  use LvsToolWeb, :live_component

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
      
      <div class="text-center py-12">
        <div class="mx-auto h-12 w-12 text-gray-400">
          <.icon name="hero-document-text" class="h-12 w-12" />
        </div>
        
        <h3 class="mt-2 text-sm font-medium text-gray-900">Keine Thesis</h3>
        
        <p class="mt-1 text-sm text-gray-500">
          Thesis-Funktionalität wird noch implementiert.
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
