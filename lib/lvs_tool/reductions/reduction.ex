defmodule LvsTool.Reductions.Reduction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reduction_types" do
    field :reduction_reason, :string
    field :reduction_lvs, :float
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reduction, attrs) do
    reduction
    |> cast(attrs, [:reduction_reason, :reduction_lvs, :description])
    |> validate_required([:reduction_reason, :reduction_lvs])
  end
end
