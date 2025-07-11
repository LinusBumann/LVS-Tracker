defmodule LvsTool.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_roles" do
    field :name, :string
    field :lvs_min, :float
    field :lvs_max, :float
    field :has_lvs, :boolean, default: false

    has_many :users, LvsTool.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :lvs_min, :lvs_max, :has_lvs])
    |> validate_required([:name, :has_lvs])
  end
end
