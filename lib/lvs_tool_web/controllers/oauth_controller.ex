defmodule LvsToolWeb.OAuthController do
  use LvsToolWeb, :controller

  alias LvsTool.OAuth.StudIP
  alias LvsTool.Accounts
  alias LvsToolWeb.UserAuth

  def index(conn, %{"provider" => provider}) do
    redirect(conn, external: authorize_url!(provider))
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    client = get_token!(provider, code)
    user_data = get_user!(provider, client)

    case Accounts.get_user_by_email(user_data.email) do
      nil -> register_oauth_user(conn, user_data)
      user -> login_oauth_user(conn, user)
    end
  rescue
    error ->
      conn
      |> put_flash(:error, "OAuth Authentifizierung fehlgeschlagen: #{inspect(error)}")
      |> redirect(to: ~p"/users/log_in")
  end

  def callback(conn, %{"provider" => _provider, "error" => error}) do
    conn
    |> put_flash(:error, "OAuth Authentifizierung abgebrochen: #{error}")
    |> redirect(to: ~p"/users/log_in")
  end

  defp authorize_url!("studip"), do: StudIP.authorize_url!(scope: "user")

  defp get_token!("studip", code), do: StudIP.get_token!(code: code)

  defp get_user!("studip", client) do
    # StudIP API Endpunkt für Benutzerinformationen
    %{body: response} = OAuth2.Client.get!(client, "/jsonapi.php/v1/users/me")

    # JSON:API Struktur parsen
    user_data = response["data"]
    attributes = user_data["attributes"]

    %{
      email: attributes["email"],
      name:
        attributes["formatted-name"] || "#{attributes["given-name"]} #{attributes["family-name"]}",
      provider: "studip",
      provider_id: user_data["id"],

      # StudIP-spezifische Felder
      username: attributes["username"],
      formatted_name: attributes["formatted-name"],
      family_name: attributes["family-name"],
      given_name: attributes["given-name"],
      name_prefix: attributes["name-prefix"],
      name_suffix: attributes["name-suffix"],
      studip_permission: attributes["permission"],
      phone: attributes["phone"],
      homepage: attributes["homepage"],
      address: attributes["address"]
    }
  end

  defp register_oauth_user(conn, user_data) do
    # Rolle basierend auf StudIP Permission zuweisen
    user_data_with_role =
      Map.put(user_data, :role_id, get_role_by_studip_permission(user_data.studip_permission))

    case Accounts.register_oauth_user(user_data_with_role) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Konto erfolgreich über #{user_data.provider} erstellt!")
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Fehler beim Erstellen des Kontos: #{inspect(changeset.errors)}")
        |> redirect(to: ~p"/users/log_in")
    end
  end

  defp login_oauth_user(conn, user) do
    conn
    |> put_flash(:info, "Erfolgreich angemeldet!")
    |> UserAuth.log_in_user(user)
  end

  # StudIP Permission zu Rolle mapping
  defp get_role_by_studip_permission("admin"), do: get_role_id_by_name("Admin")
  defp get_role_by_studip_permission("dozent"), do: get_role_id_by_name("Dozent")
  defp get_role_by_studip_permission("tutor"), do: get_role_id_by_name("Tutor")
  defp get_role_by_studip_permission("autor"), do: get_role_id_by_name("Student")
  defp get_role_by_studip_permission("user"), do: get_role_id_by_name("Student")
  # Standard
  defp get_role_by_studip_permission(_), do: get_role_id_by_name("Dozent")

  defp get_role_id_by_name(role_name) do
    case LvsTool.Repo.get_by(LvsTool.Accounts.Role, name: role_name) do
      nil -> 1
      role -> role.id
    end
  end
end
