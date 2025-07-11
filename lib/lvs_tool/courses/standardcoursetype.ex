defmodule LvsTool.Courses.Standardcoursetype do
  use Ecto.Schema
  import Ecto.Changeset

  schema "standardcoursetypes" do
    field :name, :string
    field :imputationfactor, :float
    field :abbreviation, :string

    # has_many :courses, LvsTool.Courses.Course

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(standardcoursetype, attrs) do
    standardcoursetype
    |> cast(attrs, [:name, :imputationfactor, :abbreviation])
    |> validate_required([:name, :imputationfactor, :abbreviation])
  end
end
