defmodule LvsToolWeb.PageController do
  use LvsToolWeb, :controller

  def home(conn, _params) do
    # Wenn ein Benutzer eingeloggt ist, leite direkt zu /semesterentrys weiter
    if conn.assigns[:current_user] do
      redirect(conn, to: ~p"/semesterentrys")
    else
      # The home page is often custom made,
      # so skip the default app layout.
      render(conn, :home, layout: false)
    end
  end
end
