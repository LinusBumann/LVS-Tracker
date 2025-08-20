# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LvsTool.Repo.insert!(%LvsTool.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

"""
roles = [
  %{name: "Professor/in (allgemein)", lvs_min: 18, lvs_max: 18, has_lvs: true},
  %{name: "Lehrkraft für besondere Aufgaben", lvs_min: 20, lvs_max: 24, has_lvs: true},
  %{name: "Wissenschaftliche/r Mitarbeiter/in", lvs_min: 9, lvs_max: 9, has_lvs: true},
  %{name: "Wissenschaftl. MA (befristet, Qualauftrag)", lvs_min: 4, lvs_max: 4, has_lvs: true},
  %{name: "Prof. bei gemeinsamer Berufung", lvs_min: 4.5, lvs_max: 4.5, has_lvs: true},
  %{name: "Dekanat", lvs_min: nil, lvs_max: nil, has_lvs: false},
  %{name: "Präsidium", lvs_min: nil, lvs_max: nil, has_lvs: false}
]

Enum.each(roles, fn role_attrs ->
  LvsTool.Repo.insert!(LvsTool.Accounts.Role.changeset(%LvsTool.Accounts.Role{}, role_attrs))
end)

IO.puts("Rollen wurden erfolgreich eingefügt!")
"""

# Studygroup Beispiele für Semester 1-5
"""
studygroups = [
  %{name: "EW1"},
  %{name: "EW2"},
  %{name: "EW3"},
  %{name: "EW4"},
  %{name: "EW5"},
  %{name: "SyTe1"},
  %{name: "SyTe2"},
  %{name: "SyTe3"},
  %{name: "SyTe4"},
  %{name: "SyTe5"},
  %{name: "BLVT1"},
  %{name: "BLVT2"},
  %{name: "BLVT3"},
  %{name: "BLVT4"},
  %{name: "BLVT5"}
]

# Studygroups in die Datenbank einfügen
Enum.each(studygroups, fn studygroup_attrs ->
  LvsTool.Repo.insert!(
    LvsTool.Courses.Studygroup.changeset(%LvsTool.Courses.Studygroup{}, studygroup_attrs)
  )
end)

IO.puts("Studygroup Beispiele wurden erfolgreich eingefügt!")
"""

# Standardcoursetypes gemäß LVVO
"""
standardcoursetypes = [
  %{name: "Vorlesung", abbreviation: "V", imputationfactor: 1.0},
  %{name: "Übung zur Vorlesung", abbreviation: "Ü", imputationfactor: 1.0},
  %{name: "Seminar", abbreviation: "S", imputationfactor: 1.0},
  %{name: "Workshop", abbreviation: "W", imputationfactor: 1.0},
  %{name: "Labor oder Laborprojekt", abbreviation: "L (P)", imputationfactor: 1.0},
  # Faktor: SWS x 0,5
  %{
    name: "Labor mit Laboringenieur*in gemäß § 3 Abs. 4",
    abbreviation: "L (P) mit L-Ing",
    imputationfactor: 0.5
  }
]

Enum.each(standardcoursetypes, fn type_attrs ->
  LvsTool.Repo.insert!(
    LvsTool.Courses.Standardcoursetype.changeset(
      %LvsTool.Courses.Standardcoursetype{},
      type_attrs
    )
  )
end)

IO.puts("Standardcoursetypes wurden erfolgreich eingefügt!")
"""

# Standardcoursenames aus dem Master Angewandte Informatik
"""
master_standardcoursenames = [
  %{name: "Advanced Game Programming"},
  %{name: "Maker’s Lab"},
  %{name: "Wearable Computing"},
  %{name: "Qualitative Research Methods"},
  %{name: "Mobile Engineering"},
  %{name: "Human-Computer Interaction"},
  %{name: "Medizinische Visualisierung"},
  %{name: "Design and Implementation of Programming Languages"},
  %{name: "Trends in Types and Programming Languages"},
  %{name: "Build your Startup"},
  %{name: "Blockchain Technologies"},
  %{name: "Hot Topics in IT-Security"},
  %{name: "Cryptographic Protocols"},
  %{name: "Theory of Cryptography"},
  %{name: "Advances in System Security"},
  %{name: "Mobile and IoT-Security"},
  %{name: "Current Topics in Applied Cryptography"},
  %{name: "Microcontroller Programmierung"},
  %{name: "Interaktive Systeme"}
]

Enum.each(master_standardcoursenames, fn course_attrs ->
  LvsTool.Repo.insert!(
    LvsTool.Courses.Standardcoursename.changeset(
      %LvsTool.Courses.Standardcoursename{},
      course_attrs
    )
  )
end)

IO.puts("Master-Standardcoursenames wurden erfolgreich eingefügt!")
"""

"""
# Standard-Kurs-Typ auswählen (z.B. "Vorlesung")
coursetype = LvsTool.Repo.get_by!(LvsTool.Courses.Standardcoursetype, name: "Workshop")

# Studiengruppe auswählen (z.B. "EW1")
studygroup = LvsTool.Repo.get_by!(LvsTool.Courses.Studygroup, name: "EW1")

# Standard-Kurs-Eintrag erstellen
standard_course_entry =
  LvsTool.Repo.insert!(%LvsTool.Courses.StandardCourseEntry{
    kind: "Pflicht",
    sws: 4.0,
    student_count: 150,
    percent: 100.0,
    lvs: 4.0,
    standardcoursename_id: 2,
    semesterentry_id: 1
  })

%LvsTool.Courses.CourseEntryType{
  standard_course_entry_id: standard_course_entry.id,
  standardcoursetype_id: coursetype.id
}
|> LvsTool.Repo.insert!()

%LvsTool.Courses.CourseEntryStudygroup{
  standard_course_entry_id: standard_course_entry.id,
  studygroup_id: studygroup.id
}
|> LvsTool.Repo.insert!()
"""

"""
thesis_types = [
  %{name: "Bachelorthesis (Erstbetreuung)", imputationfactor: 0.3},
  %{name: "Bachelorthesis (Zweitbetreuung)", imputationfactor: 0.15},
  %{name: "Masterthesis (Erstbetreuung)", imputationfactor: 0.4},
  %{name: "Masterthesis (Zweitbetreuung)", imputationfactor: 0.2}
]

Enum.each(thesis_types, fn attrs ->
  %LvsTool.Theses.ThesisType{}
  |> LvsTool.Theses.ThesisType.changeset(attrs)
  |> LvsTool.Repo.insert!()
end)

IO.puts("Thesis Types wurden erfolgreich eingefügt!")
"""

"""
reduction_types = [
  %{reduction_reason: "Vizepräsident", description: "bis zu 12 LVS"},
  %{reduction_reason: "Prüfungsausschuss-Vorsitzende*r", reduction_lvs: 4},
  %{reduction_reason: "Berufungsausschuss Vorsitzende*r", reduction_lvs: 2},
  %{reduction_reason: "Stundenplaner*in", reduction_lvs: 2},
  %{reduction_reason: "Vorsitz Senatsausschüsse", reduction_lvs: 1},
  %{reduction_reason: "Vorsitz Senat", reduction_lvs: 2},
  %{reduction_reason: "Dekan*in", reduction_lvs: 9},
  %{reduction_reason: "Prodekan*in", reduction_lvs: 2},
  %{reduction_reason: "Beauftragte für Studium und Lehre", reduction_lvs: 3},
  %{reduction_reason: "Studiengangsverantwortliche", description: "Bis zu 2 LVS"},
  %{
    reduction_reason: "Studiengangsverantwortliche für Reakkreditierung",
    reduction_lvs: 2,
    description: "Einmalig 2 LVS"
  },
  %{
    reduction_reason: "Semesterverantwortliche",
    reduction_lvs: 1,
    description: "Nur in den beiden Semestern
nach (Re-)Akkreditierung"
  },
  %{
    reduction_reason: "Gleichstellungsbeauftragte",
    reduction_lvs: 1,
    description: "Inklusive Stellvertretung"
  },
  %{reduction_reason: "Sonderfunktionen", description: "bis zu 2 LVS"},
  %{
    reduction_reason: "Forschung & Entwicklung, sowie Wissens- und Technologietransfer",
    description:
      "Siehe „Leitlinien der Hochschule Flensburg zur Förderung anwendungs-orientierter Forschung & Entwicklung und des Technologietransfers“"
  },
  %{
    reduction_reason: "Promotionsbetreuung",
    description:
      "Siehe „Leitlinien der Hochschule Flensburg zur Förderung anwendungs-orientierter Forschung & Entwicklung und des Technologietransfers“"
  },
  %{
    reduction_reason: "Aufgaben im öffentlichen Interesse außerhalb der Hochschule",
    description: "Ermäßigung oder Freistellung"
  },
  %{reduction_reason: "Schwerbehinderte Lehrpersonen", description: "12-25 %, je nach Grad der
Behinderung "},
  %{
    reduction_reason: "Internationalisierung",
    description:
      "Einmalig bis zu 2 LVS. Erstellung eines Lehrangebots in z.B. englischer Sprache für Module,
die im Curriculum nur einsprachig vorgesehen sind. (Die Zustimmung des Dekanats dazu muss vorliegen.)"
  }
]

Enum.each(reduction_types, fn attrs ->
  LvsTool.Repo.insert!(
    LvsTool.Reductions.ReductionType.changeset(%LvsTool.Reductions.ReductionType{}, attrs)
  )
end)

IO.puts("Reduction Types wurden erfolgreich eingefügt!")
"""

# Submission Periods Seeds - Von SoSe 25 bis SoSe 30
submission_periods = [
  # SoSe 25
  %{
    name: "SoSe 25",
    start_date: ~U[2025-01-01 00:00:00Z],
    end_date: ~U[2025-03-31 23:59:59Z]
  },

  # WiSe 25/26
  %{
    name: "WiSe 25/26",
    start_date: ~U[2025-08-01 00:00:00Z],
    end_date: ~U[2025-10-31 23:59:59Z]
  },

  # SoSe 26
  %{
    name: "SoSe 26",
    start_date: ~U[2026-01-01 00:00:00Z],
    end_date: ~U[2026-03-31 23:59:59Z]
  },

  # WiSe 26/27
  %{
    name: "WiSe 26/27",
    start_date: ~U[2026-08-01 00:00:00Z],
    end_date: ~U[2026-10-31 23:59:59Z]
  },

  # SoSe 27
  %{
    name: "SoSe 27",
    start_date: ~U[2027-01-01 00:00:00Z],
    end_date: ~U[2027-03-31 23:59:59Z]
  },

  # WiSe 27/28
  %{
    name: "WiSe 27/28",
    start_date: ~U[2027-08-01 00:00:00Z],
    end_date: ~U[2027-10-31 23:59:59Z]
  },

  # SoSe 28
  %{
    name: "SoSe 28",
    start_date: ~U[2028-01-01 00:00:00Z],
    end_date: ~U[2028-03-31 23:59:59Z]
  },

  # WiSe 28/29
  %{
    name: "WiSe 28/29",
    start_date: ~U[2028-08-01 00:00:00Z],
    end_date: ~U[2028-10-31 23:59:59Z]
  },

  # SoSe 29
  %{
    name: "SoSe 29",
    start_date: ~U[2029-01-01 00:00:00Z],
    end_date: ~U[2029-03-31 23:59:59Z]
  },

  # WiSe 29/30
  %{
    name: "WiSe 29/30",
    start_date: ~U[2029-08-01 00:00:00Z],
    end_date: ~U[2029-10-31 23:59:59Z]
  },

  # SoSe 30
  %{
    name: "SoSe 30",
    start_date: ~U[2030-01-01 00:00:00Z],
    end_date: ~U[2030-03-31 23:59:59Z]
  }
]

Enum.each(submission_periods, fn period_attrs ->
  LvsTool.Repo.insert!(
    LvsTool.SubmissionPeriods.SubmissionPeriod.changeset(
      %LvsTool.SubmissionPeriods.SubmissionPeriod{},
      period_attrs
    )
  )
end)

IO.puts("Submission Periods von SoSe 25 bis SoSe 30 wurden erfolgreich eingefügt!")
