defmodule Grid.ExploreControllerTest do
  use Grid.ConnCase

  import Mock

  setup do
    response = %{
      body: "Mocked pre-renderer",
      status_code: 200,
      headers: [{"content-type", "text/html;charset=UTF-8"}]
    }

    {:ok, get: [get!: fn(_, _, _) -> response end]}
  end

  test "Should prerender explore", %{conn: conn, get: get} do
    with_mock HTTPoison, get do
      conn = conn
        |> put_req_header("user-agent", "twitterbot")
        |> get("/explore")

      response = html_response(conn, 200)
      assert response =~ "Mocked pre-renderer"
    end
  end
end
