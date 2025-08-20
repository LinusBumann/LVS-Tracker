defmodule LvsToolWeb.RoleHelpers do
  @moduledoc """
  Helper-Funktionen für die Rollenverwaltung.

  Diese Module enthält Funktionen zur Überprüfung von Benutzerrollen
  und definiert die verfügbaren Rollen für die gesamte Anwendung.
  """

  # Definiert die verfügbaren Rollen und ihre entsprechenden IDs.
  # Rollen:
  # - lehrperson: Rollen 1-5 (Professoren, Dozenten, etc.)
  # - dekan: Rolle 6 (Dekan)
  # - praesidium: Rolle 7 (Präsidium)
  # - dekan_or_praesidium: Rollen 6-7 (Dekan oder Präsidium)
  @roles %{
    lehrperson: [1, 2, 3, 4, 5],
    dekan: 6,
    praesidium: 7,
    dekan_or_praesidium: [6, 7]
  }

  @doc """
  Überprüft, ob ein Benutzer eine bestimmte Rolle hat.

  ## Parameter
  - `user_role`: Die Benutzerrolle (Struct mit `id` Feld)
  - `role_name`: Der Name der zu überprüfenden Rolle (Atom)

  ## Beispiele

      iex> is_role?(%{id: 1}, :lehrperson)
      true

      iex> is_role?(%{id: 6}, :dekan)
      true

      iex> is_role?(%{id: 7}, :dekan_or_praesidium)
      true

      iex> is_role?(%{id: 1}, :dekan)
      false
  """
  def is_role?(user_role, role_name) do
    case role_name do
      :lehrperson -> user_role.id in [1, 2, 3, 4, 5]
      :dekan -> user_role.id == 6
      :praesidium -> user_role.id == 7
      :dekan_or_praesidium -> user_role.id in [6, 7]
      _ -> false
    end
  end

  @doc """
  Gibt die Rollen-Map zurück.

  ## Beispiele

      iex> get_roles()
      %{
        lehrperson: [1, 2, 3, 4, 5],
        dekan: 6,
        praesidium: 7,
        dekan_or_praesidium: [6, 7]
      }
  """
  def get_roles, do: @roles

  @doc """
  Überprüft, ob ein Benutzer eine Lehrperson ist.

  ## Parameter
  - `user_role`: Die Benutzerrolle (Struct mit `id` Feld)

  ## Beispiele

      iex> is_teacher?(%{id: 1})
      true

      iex> is_teacher?(%{id: 6})
      false
  """
  def is_teacher?(user_role), do: is_role?(user_role, :lehrperson)

  @doc """
  Überprüft, ob ein Benutzer ein Dekan ist.

  ## Parameter
  - `user_role`: Die Benutzerrolle (Struct mit `id` Feld)

  ## Beispiele

      iex> is_dean?(%{id: 6})
      true

      iex> is_dean?(%{id: 1})
      false
  """
  def is_dean?(user_role), do: is_role?(user_role, :dekan)

  @doc """
  Überprüft, ob ein Benutzer zum Präsidium gehört.

  ## Parameter
  - `user_role`: Die Benutzerrolle (Struct mit `id` Feld)

  ## Beispiele

      iex> is_presidium?(%{id: 7})
      true

      iex> is_presidium?(%{id: 1})
      false
  """
  def is_presidium?(user_role), do: is_role?(user_role, :praesidium)

  @doc """
  Überprüft, ob ein Benutzer Dekan oder Präsidium ist.

  ## Parameter
  - `user_role`: Die Benutzerrolle (Struct mit `id` Feld)

  ## Beispiele

      iex> is_dean_or_presidium?(%{id: 6})
      true

      iex> is_dean_or_presidium?(%{id: 7})
      true

      iex> is_dean_or_presidium?(%{id: 1})
      false
  """
  def is_dean_or_presidium?(user_role), do: is_role?(user_role, :dekan_or_praesidium)
end
