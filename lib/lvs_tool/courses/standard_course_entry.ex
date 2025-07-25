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
      join_through: "course_entry_types"

    # Liefert den Kursnamen
    belongs_to :standardcoursename, LvsTool.Courses.Standardcoursename
    belongs_to :semesterentry, LvsTool.Semesterentrys.Semesterentry

    # Liefert die Studiengruppe
    many_to_many :studygroups, LvsTool.Courses.Studygroup,
      join_through: "course_entry_studygroups"

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
  end
end
