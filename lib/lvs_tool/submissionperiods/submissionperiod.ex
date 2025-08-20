defmodule LvsTool.SubmissionPeriods.SubmissionPeriod do
  use Ecto.Schema
  import Ecto.Changeset

  schema "submission_periods" do
    field :name, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(submission_period, attrs) do
    submission_period
    |> cast(attrs, [:name, :start_date, :end_date])
    |> validate_required([:name, :start_date, :end_date])
    # Empfohlene Ergänzungen:
    |> validate_length(:name,
      min: 6,
      max: 10,
      message: "Die Länge des Semesternamens muss zwischen 6 und 10 Zeichen betragen."
    )
    |> validate_date_order()
    |> validate_name()
  end

  defp validate_name(changeset) do
    name =
      get_field(changeset, :name)
      |> String.split(" ", parts: 2, trim: true)

    case name do
      ["SoSe", year] ->
        if Regex.match?(~r/^\d{2}$/, year) do
          changeset
        else
          add_error(
            changeset,
            :name,
            "SoSe muss im Format 'SoSe XX' angegeben werden (z.B. 'SoSe 25')"
          )
        end

      ["WiSe", year_parts] ->
        if Regex.match?(~r/^\d{2}\/\d{2}$/, year_parts) do
          String.split(year_parts, "/")
          |> case do
            [first_year, second_year] when first_year > second_year ->
              add_error(
                changeset,
                :name,
                "Beim WiSe muss das erste Jahr vor dem zweiten Jahr liegen (z.B. 'WiSe 25/26')."
              )

            [first_year, second_year] when first_year == second_year ->
              add_error(
                changeset,
                :name,
                "Beim WiSe dürfen das erste Jahr und das zweite Jahr nicht gleich sein."
              )

            _ ->
              changeset
          end
        else
          add_error(
            changeset,
            :name,
            "WiSe muss im Format 'WiSe XX/XX' angegeben werden (z.B. 'WiSe 25/26')"
          )
        end

      _ ->
        add_error(
          changeset,
          :name,
          "Ist ungültig. Bitte geben Sie den Namen bspw. im Format 'SoSe XX' oder 'WiSe XX/XX' ein."
        )
    end
  end

  defp validate_date_order(changeset) do
    start_date = get_field(changeset, :start_date)
    end_date = get_field(changeset, :end_date)

    if start_date && end_date && DateTime.compare(start_date, end_date) != :lt do
      add_error(changeset, :enddate, "Das Enddatum muss nach dem Startdatum liegen.")
    else
      changeset
    end
  end
end
