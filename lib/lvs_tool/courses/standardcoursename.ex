defmodule LvsTool.Courses.Standardcoursename do
  use Ecto.Schema
  import Ecto.Changeset

  schema "standardcoursenames" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(standardcoursename, attrs) do
    standardcoursename
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
