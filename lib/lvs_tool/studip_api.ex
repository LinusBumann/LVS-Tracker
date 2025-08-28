defmodule LvsTool.StudipApi do
  @moduledoc """
  StudIP API Client für das Abrufen von Kursdaten
  """

  alias OAuth2.Client

  @doc """
  Ruft alle Kurse des eingeloggten Benutzers für ein bestimmtes Semester ab.
  """
  def get_user_courses(access_token, semester_id \\ nil) do
    client = build_client(access_token)

    # Aktuelles Semester ermitteln falls nicht angegeben
    semester_id = semester_id || get_current_semester_id(client)

    case Client.get(client, "/jsonapi.php/v1/users/me/courses") do
      {:ok, %{body: response}} ->
        courses = response["data"] || []

        # Filtere Kurse nach Semester falls Semester-ID verfügbar
        filtered_courses =
          if semester_id do
            filter_courses_by_semester(courses, semester_id)
          else
            courses
          end

        {:ok, parse_courses(filtered_courses)}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Ruft Kurse ab, in denen der Benutzer als Dozent/Tutor tätig ist.
  """
  def get_teaching_courses(access_token, semester_id \\ nil) do
    case get_user_courses(access_token, semester_id) do
      {:ok, courses} ->
        # Filtere nur Kurse, in denen der Benutzer Lehrrechte hat
        teaching_courses =
          Enum.filter(courses, fn course ->
            course.user_permission in ["dozent", "tutor"]
          end)

        {:ok, teaching_courses}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Ruft verfügbare Semester ab.
  """
  def get_semesters(access_token) do
    client = build_client(access_token)

    case Client.get(client, "/jsonapi.php/v1/semesters") do
      {:ok, %{body: response}} ->
        semesters = response["data"] || []
        {:ok, parse_semesters(semesters)}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Ruft Details zu einem spezifischen Kurs ab.
  """
  def get_course_details(access_token, course_id) do
    client = build_client(access_token)

    case Client.get(client, "/jsonapi.php/v1/courses/#{course_id}") do
      {:ok, %{body: response}} ->
        course_data = response["data"]
        {:ok, parse_course_details(course_data)}

      {:error, error} ->
        {:error, error}
    end
  end

  # Private Funktionen

  defp build_client(access_token) do
    OAuth2.Client.new(
      site: "https://elearning.hs-flensburg.de",
      token: %OAuth2.AccessToken{access_token: access_token}
    )
    |> Client.put_header("Accept", "application/vnd.api+json")
    |> Client.put_header("User-Agent", "LvsTool Phoenix App")
    |> Client.put_serializer("application/json", Jason)
  end

  defp get_current_semester_id(client) do
    case Client.get(client, "/jsonapi.php/v1/semesters") do
      {:ok, %{body: response}} ->
        semesters = response["data"] || []

        current_semester =
          Enum.find(semesters, fn semester ->
            attributes = semester["attributes"]
            now = DateTime.utc_now()

            case {parse_date(attributes["begin"]), parse_date(attributes["end"])} do
              {begin_date, end_date} when not is_nil(begin_date) and not is_nil(end_date) ->
                DateTime.compare(now, begin_date) != :lt and
                  DateTime.compare(now, end_date) != :gt

              _ ->
                false
            end
          end)

        if current_semester, do: current_semester["id"], else: nil

      _ ->
        nil
    end
  end

  defp filter_courses_by_semester(courses, semester_id) do
    Enum.filter(courses, fn course ->
      # StudIP API kann Semester-Informationen in relationships haben
      semester_data = get_in(course, ["relationships", "semester", "data"])

      case semester_data do
        %{"id" => ^semester_id} -> true
        _ -> false
      end
    end)
  end

  defp parse_courses(courses) do
    Enum.map(courses, fn course ->
      attributes = course["attributes"]

      %{
        id: course["id"],
        title: attributes["title"],
        subtitle: attributes["subtitle"],
        course_type: attributes["course-type"],
        number: attributes["number"],
        user_permission: get_user_permission(course),
        semester: get_semester_info(course)
      }
    end)
  end

  defp parse_semesters(semesters) do
    Enum.map(semesters, fn semester ->
      attributes = semester["attributes"]

      %{
        id: semester["id"],
        title: attributes["title"],
        description: attributes["description"],
        begin: parse_date(attributes["begin"]),
        end: parse_date(attributes["end"])
      }
    end)
  end

  defp parse_course_details(course) do
    attributes = course["attributes"]

    %{
      id: course["id"],
      title: attributes["title"],
      subtitle: attributes["subtitle"],
      description: attributes["description"],
      course_type: attributes["course-type"],
      number: attributes["number"],
      location: attributes["location"],
      miscellaneous: attributes["miscellaneous"],
      ects: attributes["ects"]
    }
  end

  defp get_user_permission(course) do
    # StudIP API liefert Benutzer-Berechtigung für den Kurs
    # Dies kann in verschiedenen Teilen der API-Antwort stehen
    course["attributes"]["user-permission"] || "user"
  end

  defp get_semester_info(course) do
    # Semester-Informationen aus relationships extrahieren
    case get_in(course, ["relationships", "semester", "data"]) do
      %{"id" => id} -> %{id: id}
      _ -> nil
    end
  end

  defp parse_date(date_string) when is_binary(date_string) do
    case DateTime.from_unix(String.to_integer(date_string)) do
      {:ok, datetime} -> datetime
      _ -> nil
    end
  rescue
    _ -> nil
  end

  defp parse_date(_), do: nil
end
