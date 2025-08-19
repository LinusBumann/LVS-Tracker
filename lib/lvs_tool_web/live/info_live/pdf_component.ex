defmodule LvsToolWeb.InfoLive.Pdf do
  use LvsToolWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="space-y-6 w-full">
      <.header>
        {@page_title}
      </.header>
      
      <div class="w-full h-full">
        <iframe
          src={@pdf_file}
          width="100%"
          height="600px"
          class="border border-gray-300 rounded-lg"
          title="PDF Viewer"
        >
        </iframe>
      </div>
      
      <.link
        patch={~p"/infos"}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" /> Zurück zu Infos
      </.link>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end
end
