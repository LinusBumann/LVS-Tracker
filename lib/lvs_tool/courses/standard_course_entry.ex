defmodule LvsTool.Courses.StandardCourseEntry do
  @moduledoc """
  Das Schema `StandardCourseEntry` repräsentiert einen standardisierten Kurseintrag.

  ## Felder

    * `:kind` – Art des Kurses (z.B. Pflicht, Wahlpflicht, etc.)
    * `:sws` – Semesterwochenstunden (SWS) des Kurses
    * `:student_count` – Anzahl der teilnehmenden Studierenden
    * `:percent` – Prozentualer Anteil (z.B. für Anrechnung, Teamteaching etc.)
    * `:lvs` – Lehrveranstaltungsstunden (LVS), ggf. berechnet

  ## Beziehungen

    * `many_to_many :standardcoursetypes` – Verknüpfung zu Kurstypen (z.B. Vorlesung, Seminar)
    * `belongs_to :standardcoursename` – Verknüpfung zum Kursnamen (z.B. "Programmieren 1")
    * `many_to_many :studygroups` – Verknüpfung zu Studiengruppen (z.B. "EW1")

  Dieses Schema dient der Abbildung und Verwaltung von standardisierten Kurseinträgen
  im System, inklusive aller relevanten Zuordnungen und Berechnungsgrundlagen.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "standard_course_entries" do
    field :kind, :string
    field :sws, :float
    field :student_count, :integer
    field :percent, :float
    field :lvs, :float

    # Liefert auch den Anrechnungsfaktor
    many_to_many :standardcoursetypes, LvsTool.Courses.Standardcoursetype,
      join_through: "course_entry_types",
      on_replace: :delete

    # Liefert den Kursnamen
    belongs_to :standardcoursename, LvsTool.Courses.Standardcoursename
    belongs_to :semesterentry, LvsTool.Semesterentrys.Semesterentry

    # Liefert die Studiengruppe
    many_to_many :studygroups, LvsTool.Courses.Studygroup,
      join_through: "course_entry_studygroups",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(standard_course_entry, attrs) do
    standard_course_entry
    |> cast(attrs, [
      :kind,
      :sws,
      :student_count,
      :percent,
      :lvs,
      :standardcoursename_id,
      :semesterentry_id
    ])
    |> validate_required([
      :kind,
      :sws,
      :student_count,
      :percent,
      :lvs,
      :standardcoursename_id,
      :semesterentry_id
    ])
    |> put_assoc(:standardcoursetypes, parse_standardcoursetypes(attrs))
    |> put_assoc(:studygroups, parse_studygroups(attrs))
  end

  defp parse_standardcoursetypes(attrs) do
    case attrs do
      %{"standardcoursetype_ids" => ids} when is_list(ids) ->
        ids
        |> Enum.reject(&(&1 == "" || is_nil(&1)))
        |> Enum.map(fn id ->
          case id do
            id when is_binary(id) -> String.to_integer(id)
            id when is_integer(id) -> id
            _ -> nil
          end
        end)
        |> Enum.reject(&is_nil/1)
        |> Enum.map(&LvsTool.Repo.get!(LvsTool.Courses.Standardcoursetype, &1))

      %{"standardcoursetype_ids" => ids} when is_binary(ids) ->
        [LvsTool.Repo.get!(LvsTool.Courses.Standardcoursetype, String.to_integer(ids))]

      _ ->
        []
    end
  end

  defp parse_studygroups(attrs) do
    case attrs do
      %{"studygroup_ids" => ids} when is_list(ids) ->
        ids
        |> Enum.reject(&(&1 == "" || is_nil(&1)))
        |> Enum.map(fn id ->
          case id do
            id when is_binary(id) -> String.to_integer(id)
            id when is_integer(id) -> id
            _ -> nil
          end
        end)
        |> Enum.reject(&is_nil/1)
        |> Enum.map(&LvsTool.Repo.get!(LvsTool.Courses.Studygroup, &1))

      %{"studygroup_ids" => ids} when is_binary(ids) ->
        [LvsTool.Repo.get!(LvsTool.Courses.Studygroup, String.to_integer(ids))]

      _ ->
        []
    end
  end
end
