defmodule LvsTool.OAuth.StudIP do
  @moduledoc """
  Eine OAuth2 Strategie für StudIP.
  """
  use OAuth2.Strategy

  defp config do
    [
      strategy: __MODULE__,
      site: "https://elearning.hs-flensburg.de",
      authorize_url: "/dispatch.php/api/oauth2/authorize",
      token_url: "/dispatch.php/api/oauth2/token"
    ]
  end

  def client do
    Application.get_env(:lvs_tool, StudIP)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
    # JSON:API Content-Type
    |> OAuth2.Client.put_header("Accept", "application/vnd.api+json")
    |> OAuth2.Client.put_header("User-Agent", "LvsTool Phoenix App")
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def authorize_url!(params \\ []), do: OAuth2.Client.authorize_url!(client(), params)

  def get_token!(params), do: OAuth2.Client.get_token!(client(), params)

  # Implementiere die erforderlichen OAuth2.Strategy Callbacks
  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    OAuth2.Strategy.AuthCode.get_token(client, params, headers)
  end
end
