defmodule LvsToolWeb.SemesterentryLive.StandardCoursesComponent do
  use LvsToolWeb, :live_component

  alias LvsTool.Courses
  alias LvsTool.Repo
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
      
      <div class="bg-white shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <div class="flow-root">
            <ul role="list" class="-my-5 divide-y divide-gray-200">
              <li :for={course <- @standard_courses} class="py-4">
                <div class="flex items-center space-x-4">
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-gray-900 truncate">
                      {course.standardcoursename.name}
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      {course.kind} • {course.sws} SWS • {course.student_count} Studierende • {course.percent}%
                    </p>
                    
                    <p class="text-sm text-gray-500">
                      LVS: {course.lvs}
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
                      phx-click={JS.push("delete_standard_course", value: %{id: course.id})}
                      phx-target={@myself}
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
      
      <div :if={@standard_courses == []} class="text-center py-12">
        <div class="mx-auto h-12 w-12 text-gray-400">
          <.icon name="hero-academic-cap" class="h-12 w-12" />
        </div>
        
        <h3 class="mt-2 text-sm font-medium text-gray-900">Keine Standard-Kurse</h3>
        
        <p class="mt-1 text-sm text-gray-500">
          Fügen Sie Ihren ersten Standard-Kurs hinzu.
        </p>
        
        <div class="mt-6">
          <.link patch={~p"/semesterentrys/#{@semesterentry.id}/standard-courses/new"}>
            <.button>Standard-Kurs hinzufügen</.button>
          </.link>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    # Temporär alle Standard-Kurse laden, bis die semesterentry_id Spalte hinzugefügt wurde
    standard_courses =
      Courses.list_standard_course_entries()
      |> Repo.preload([:standardcoursename, :standardcoursetypes, :studygroups])

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:standard_courses, standard_courses)}
  end

  @impl true
  def handle_event("delete_standard_course", %{"id" => _id}, socket) do
    # TODO: Implement delete standard course
    {:noreply, socket}
  end
end
