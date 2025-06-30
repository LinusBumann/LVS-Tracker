defmodule LvsTool.Repo do
  use Ecto.Repo,
    otp_app: :lvs_tool,
    adapter: Ecto.Adapters.Postgres
end
