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
