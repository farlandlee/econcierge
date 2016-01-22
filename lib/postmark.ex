defmodule Postmark do
  use HTTPoison.Base


  ###############
  ##    API    ##
  ###############

  def email(to, body, subject \\ "Test") do
    content = Poison.encode! %{
      "From" => "matt.enlow@outpostjh.com",
      "To" => to,
      "Subject" => subject,
      "Tag" => "Test Emails",
      "HtmlBody" => body
    }
    {:ok, %{status_code: 200, body: body}} = post("/email", content)
    body
  end


  ###############
  ## Callbacks ##
  ###############
  @endpoint "https://api.postmarkapp.com/"
  def process_url(url) do
    @endpoint <> url
  end

  def process_request_headers(headers) do
    headers
    |> Dict.put(:"Accept", "application/json")
    |> Dict.put(:"Content-Type", "application/json")
    |> Dict.put(:"X-Postmark-Server-Token", Application.get_env(:grid, :postmark_server_token))
  end

  def process_response_body(body) do
    Poison.decode! body
  end

end
