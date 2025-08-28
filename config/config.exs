# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :lvs_tool, StudIP,
  client_id: System.get_env("STUDIP_CLIENT_ID"),
  client_secret: System.get_env("STUDIP_CLIENT_SECRET"),
  redirect_uri:
    System.get_env("STUDIP_REDIRECT_URI") || "http://localhost:4000/auth/studip/callback"

config :lvs_tool,
  ecto_repos: [LvsTool.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :lvs_tool, LvsToolWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: LvsToolWeb.ErrorHTML, json: LvsToolWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: LvsTool.PubSub,
  live_view: [signing_salt: "jaxysDz9"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :lvs_tool, LvsTool.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  lvs_tool: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  lvs_tool: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
