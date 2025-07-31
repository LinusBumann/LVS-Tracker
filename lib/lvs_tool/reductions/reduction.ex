defmodule LvsTool.Reductions.Reduction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reduction_types" do
    field :reduction_reason, :string
    field :reduction_lvs, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reduction, attrs) do
    reduction
    |> cast(attrs, [:reduction_reason, :reduction_lvs])
    |> validate_required([:reduction_reason, :reduction_lvs])
  end
end
