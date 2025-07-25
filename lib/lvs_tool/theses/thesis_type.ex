defmodule LvsTool.Theses.ThesisType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "thesis_types" do
    field :name, :string
    field :imputationfactor, :float

    many_to_many :theses_entries, LvsTool.Theses.ThesisEntry,
      join_through: "thesis_entry_types",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thesis_type, attrs) do
    thesis_type
    |> cast(attrs, [:name, :imputationfactor])
    |> validate_required([:name, :imputationfactor])
  end
end
