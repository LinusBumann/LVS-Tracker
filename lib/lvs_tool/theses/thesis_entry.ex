defmodule LvsTool.Theses.ThesisEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "theses_entries" do
    field :percent, :float
    field :lvs, :float

    belongs_to :semesterentry, LvsTool.Semesterentrys.Semesterentry

    many_to_many :thesis_types, LvsTool.Theses.ThesisType,
      join_through: "thesis_entry_types",
      on_replace: :delete

    many_to_many :studygroups, LvsTool.Courses.Studygroup,
      join_through: "thesis_entry_studygroups",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thesis_entry, attrs) do
    thesis_entry
    |> cast(attrs, [:percent, :lvs, :semesterentry_id])
    |> validate_required([:percent, :lvs, :semesterentry_id])
    |> put_assoc(:thesis_types, parse_standardthesistypes(attrs))
    |> put_assoc(:studygroups, parse_studygroups(attrs))
  end

  defp parse_standardthesistypes(attrs) do
    case attrs do
      %{"thesistype_ids" => ids} when is_list(ids) ->
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
        |> Enum.map(&LvsTool.Repo.get!(LvsTool.Theses.ThesisType, &1))

      %{"thesistype_ids" => ids} when is_binary(ids) ->
        [LvsTool.Repo.get!(LvsTool.Theses.ThesisType, String.to_integer(ids))]

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
