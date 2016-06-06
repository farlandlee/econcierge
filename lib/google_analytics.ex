defmodule GoogleAnalytics do
  @api_endpoint "https://analyticsreporting.googleapis.com/v4/reports:batchGet"

  def load_slide_clicks(token, view_id) do
    body = %{
      "reportRequests" => [
        %{
          "viewId" => view_id,
          "dateRanges" => [
            %{"startDate" => "2016-03-01", "endDate" => "today"} # Add UI to choose date range 
          ],
          "metrics" => [
            %{"expression" => "ga:totalEvents"}
          ],
          "dimensions" => [
            %{"name" => "ga:eventLabel"}
          ]
        }
      ]
    }

    case HTTPoison.post(@api_endpoint, Poison.encode!(body), headers(token)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        results = Poison.decode!(body)
        process_slide_clicks(results)
      _ -> %{}
    end
  end

  defp headers(token) do
    [
      {"Authorization", "Bearer #{token}"},
      {"Accept", "application/json"}
    ]
  end

  defp process_slide_clicks(%{"reports" => [report]}) do
    Enum.reduce(report["data"]["rows"], %{}, fn(row, acc) ->
      slide_id = row["dimensions"] |> hd
      count = row["metrics"] |> hd |> Map.get("values") |> hd

      Map.put(acc, slide_id, count)
    end)
  end
end
