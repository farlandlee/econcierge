defmodule Google do
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode
  alias Grid.Router.Helpers

  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: Grid.fetch_env!(:google_client_id),
      client_secret: Grid.fetch_env!(:google_client_secret),
      redirect_uri: Helpers.auth_url(Grid.Endpoint, :callback, "google"),
      site: "https://accounts.google.com",
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      token_url: "https://accounts.google.com/o/oauth2/token",
      access_type: "offline"
    ])
  end

  def authorize_url!(params \\ []) do
    client()
    |> put_param(:hd, "outpostjh.com")
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), params, headers)
  end

  def get_user!(token) do
    user_url = "https://www.googleapis.com/plus/v1/people/me/openIdConnect"

    user = OAuth2.AccessToken.get!(token, user_url)
      |> Map.fetch!(:body)

    user
    |> Map.put("ga_token", token.access_token)
    |> Map.put("ga_refresh_token", token.refresh_token) # TODO: add this to user db
    |> Map.put("image", user["picture"])
    |> Map.delete("picture")
  end

  # strategy callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
