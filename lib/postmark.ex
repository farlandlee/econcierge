defmodule Postmark do
  use HTTPoison.Base

  ###############
  ##    API    ##
  ###############
  def email(_, _, _, _, :test), do: nil
  def email(to, body, subject, tag, :production), do: email(to, body, subject, tag)
  def email(to, body, subject, tag, env),
    do: email(to, body, "[#{env}] #{subject}", "[#{env}] #{tag}")


  def email(to, body, subject, tag) do
    content = Poison.encode! %{
      "From" => "book@outpostjh.com",
      "To" => to,
      "Bcc" => "book@outpostjh.com, jhopple@gmail.com",
      "Subject" => subject,
      "Tag" => tag,
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
    |> Dict.put(:"X-Postmark-Server-Token", Grid.fetch_env!(:postmark_server_token))
  end

  def process_response_body(body) do
    Poison.decode! body
  end

end
