defmodule LvsTool.Projects.ProjectEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_entries" do
    field :name, :string
    field :kind, :string
    field :sws, :float
    field :student_count, :integer
    field :percent, :float
    field :lvs, :float

    belongs_to :semesterentry, LvsTool.Semesterentrys.Semesterentry

    many_to_many :studygroups, LvsTool.Courses.Studygroup,
      join_through: "project_entry_studygroups",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project_entry, attrs) do
    project_entry
    |> cast(attrs, [:name, :kind, :sws, :student_count, :percent, :lvs, :semesterentry_id])
    |> validate_required([:name, :kind, :sws, :student_count, :percent, :lvs, :semesterentry_id])
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

      %{"studygroup_ids" => ids} when is_binary(ids) ->
        [LvsTool.Repo.get!(LvsTool.Courses.Studygroup, String.to_integer(ids))]

      _ ->
        []
    end
  end
end
