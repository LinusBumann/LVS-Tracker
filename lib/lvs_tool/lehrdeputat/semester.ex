defmodule LvsTool.Lehrdeputat.Semester do
  use Ecto.Schema
  import Ecto.Changeset

  schema "semesters" do
    field :name, :string
    field :user_name, :string

    belongs_to :user, LvsTool.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(semester, attrs) do
    semester
    |> cast(attrs, [:name, :user_name, :user_id])
    |> validate_required([:name, :user_name, :user_id])
  end
end
