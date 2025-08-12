defmodule LvsToolWeb.SemesterentryLive.StandardCoursesComponent do
  use LvsToolWeb, :live_component

  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <div class="flex justify-between items-center">
        <h2 class="text-xl font-semibold text-gray-900">Standard-Kurse</h2>
        
        <.link patch={~p"/semesterentrys/#{@semesterentry.id}/standard-courses/new"}>
          <.button>
            <span class="flex items-center gap-2">
              <.icon name="hero-plus" class="h-4 w-4" /> Standard-Kurs hinzufügen
            </span>
          </.button>
        </.link>
      </div>
      
      <div :if={Enum.count(@standard_course_entries) > 0} class="bg-white shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <div class="flow-root">
            <ul
              role="list"
              phx-update="stream"
              id="standard-course-entries-list"
              class="-my-5 divide-y divide-gray-200"
            >
              <li :for={{dom_id, course} <- @standard_course_entries} id={dom_id} class="py-4">
                <div class="flex items-center space-x-4">
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-gray-900 truncate">
                      {course.standardcoursename.name}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Kurstypen:</span> {Enum.map(
                        course.standardcoursetypes,
                        fn type -> type.name end
                      )}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Studiengruppen:</span> {Enum.map(
                        course.studygroups,
                        fn group -> group.name end
                      )}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Anzahl der Studierenden:</span> {course.student_count}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Prozentualer Anteil:</span> {course.percent}%
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">Kursart:</span> {course.kind}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">SWS:</span> {course.sws}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      <span class="font-semibold">LVS:</span> {course.lvs}
                    </p>
                  </div>
                  
                  <div class="flex items-center space-x-2">
                    <.link patch={
                      ~p"/semesterentrys/#{@semesterentry.id}/standard-courses/#{course.id}/edit"
                    }>
                      <.button class="text-blue-600 hover:text-blue-900">
                        <.icon name="hero-pencil-square" class="h-4 w-4" />
                      </.button>
                    </.link>
                    
                    <.button
                      phx-click={
                        JS.push("delete_standard_course", target: @myself, value: %{id: course.id})
                      }
                      phx-target={@myself}
                      data-confirm="Sind Sie sicher, dass Sie diesen Standard-Kurs löschen möchten?"
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
      
      <div :if={Enum.count(@standard_course_entries) == 0} class="text-center py-12">
        <div class="mx-auto h-12 w-12 text-gray-400">
          <.icon name="hero-academic-cap" class="h-12 w-12" />
        </div>
        
        <h3 class="mt-2 text-sm font-medium text-gray-900">Keine Standard-Kurse</h3>
        
        <p class="mt-1 text-sm text-gray-500">
          Fügen Sie Ihren ersten Standard-Kurs hinzu.
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
  def handle_event("delete_standard_course", %{"id" => id}, socket) do
    notify_parent({:deleted_standard_course, id})
    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
