defmodule LvsTool.Theses.ThesisType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "thesis_types" do
    field :name, :string
    field :imputationfactor, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thesis_type, attrs) do
    thesis_type
    |> cast(attrs, [:name, :imputationfactor])
    |> validate_required([:name, :imputationfactor])
  end
end
