defmodule Wordpress do
  @api_endpoint "http://www.outpostjh.com/wp-json/wp/v2/"

  def load_concierge_articles() do
    case HTTPoison.get(@api_endpoint <> "concierge-api/?per_page=100&order=asc&orderby=menu_order&exclude=5326") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)
      _ -> []
    end
  end
end
