defmodule LvsTool.Semesterentrys.Semesterentry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "semesterentrys" do
    field :name, :string
    field :status, :string

    belongs_to :user, LvsTool.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(semesterentry, attrs) do
    semesterentry
    |> cast(attrs, [:name, :status, :user_id])
    |> validate_required([:name, :status, :user_id])
  end
end
