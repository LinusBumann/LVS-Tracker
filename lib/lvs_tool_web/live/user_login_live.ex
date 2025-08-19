defmodule LvsToolWeb.UserLoginLive do
  use LvsToolWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        In Account einloggen
        <:subtitle>
          Du hast noch keinen Account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Registrieren
          </.link>
          für einen Account.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="E-Mail" required />
        <.input field={@form[:password]} type="password" label="Passwort" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Eingeloggt bleiben" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Passwort vergessen?
          </.link>
        </:actions>
        <:actions>
          <.login_register_button phx-disable-with="Einloggen..." class="w-full">
            Einloggen <span aria-hidden="true">→</span>
          </.login_register_button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
