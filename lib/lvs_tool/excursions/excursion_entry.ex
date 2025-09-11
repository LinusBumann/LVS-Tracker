defmodule LvsTool.Excursions.ExcursionEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "excursion_entries" do
    field :name, :string
    field :lvs, :float
    field :student_count, :integer
    field :daily_max_teaching_units, :integer
    field :imputationfactor, :float, default: 0.3

    belongs_to :semesterentry, LvsTool.Semesterentrys.Semesterentry

    many_to_many :studygroups, LvsTool.Courses.Studygroup,
      join_through: "excursion_entry_studygroups",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(excursion_entry, attrs) do
    excursion_entry
    |> cast(attrs, [
      :name,
      :lvs,
      :student_count,
      :daily_max_teaching_units,
      :semesterentry_id
    ])
    |> validate_required([
      :name,
      :lvs,
      :student_count,
      :daily_max_teaching_units,
      :semesterentry_id
    ])
    |> put_assoc(:studygroups, parse_studygroups(attrs))
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
    end
  end
end
