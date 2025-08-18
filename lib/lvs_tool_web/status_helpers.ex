defmodule LvsToolWeb.StatusHelpers do
  @moduledoc """
  Helper-Funktionen für die Statusverwaltung von Semestereinträgen.

  Diese Module enthält Funktionen zur Überprüfung von Semestereintrag-Status
  und definiert die verfügbaren Status für die gesamte Anwendung.
  """

  # Definiert die verfügbaren Status und ihre Gruppierungen
  @statuses %{
    # Status, bei denen Lehrpersonen noch Änderungen vornehmen können
    editable: ["Offen", "Abgelehnt"],

    # Status, bei denen Lehrpersonen keine Änderungen mehr vornehmen können
    non_editable: ["Eingereicht", "An das Präsidium weitergeleitet", "Akzeptiert"],

    # Status für Dekan-Aktionen
    dekan_actions: ["Eingereicht"],

    # Status für Präsidium-Aktionen
    praesidium_actions: ["An das Präsidium weitergeleitet"],

    # Status für Ablehnung durch Dekan/Präsidium
    rejectable: ["Eingereicht", "An das Präsidium weitergeleitet"]
  }

  @doc """
  Überprüft, ob ein Semestereintrag noch bearbeitbar ist.

  ## Parameter
  - `status`: Der Status des Semestereintrags (String)

  ## Beispiele

      iex> is_editable?("Offen")
      true

      iex> is_editable?("Eingereicht")
      false
  """
  def is_editable?(status), do: status in @statuses.editable

  @doc """
  Überprüft, ob ein Semestereintrag nicht mehr bearbeitbar ist.

  ## Parameter
  - `status`: Der Status des Semestereintrags (String)

  ## Beispiele

      iex> is_non_editable?("Eingereicht")
      true

      iex> is_non_editable?("Offen")
      false
  """
  def is_non_editable?(status), do: status in @statuses.non_editable

  @doc """
  Überprüft, ob ein Semestereintrag für Dekan-Aktionen bereit ist.

  ## Parameter
  - `status`: Der Status des Semestereintrags (String)

  ## Beispiele

      iex> is_dekan_actionable?("Eingereicht")
      true

      iex> is_dekan_actionable?("Offen")
      false
  """
  def is_dekan_actionable?(status), do: status in @statuses.dekan_actions

  @doc """
  Überprüft, ob ein Semestereintrag für Präsidium-Aktionen bereit ist.

  ## Parameter
  - `status`: Der Status des Semestereintrags (String)

  ## Beispiele

      iex> is_praesidium_actionable?("An das Präsidium weitergeleitet")
      true

      iex> is_praesidium_actionable?("Eingereicht")
      false
  """
  def is_praesidium_actionable?(status), do: status in @statuses.praesidium_actions

  @doc """
  Überprüft, ob ein Semestereintrag abgelehnt werden kann.

  ## Parameter
  - `status`: Der Status des Semestereintrags (String)

  ## Beispiele

      iex> is_rejectable?("Eingereicht")
      true

      iex> is_rejectable?("Offen")
      false
  """
  def is_rejectable?(status), do: status in @statuses.rejectable

  @doc """
  Gibt die Status-Map zurück.

  ## Beispiele

      iex> get_statuses()
      %{
        editable: ["Offen", "Abgelehnt"],
        non_editable: ["Eingereicht", "An das Präsidium weitergeleitet", "Bestätigt", "Akzeptiert"],
        ...
      }
  """
  def get_statuses, do: @statuses

  @doc """
  Überprüft, ob ein Semestereintrag für Einreichung bereit ist.

  ## Parameter
  - `status`: Der Status des Semestereintrags (String)

  ## Beispiele

      iex> can_be_submitted?("Offen")
      true

      iex> can_be_submitted?("Eingereicht")
      false
  """
  def can_be_submitted?(status), do: status in ["Offen", "Abgelehnt"]
end
