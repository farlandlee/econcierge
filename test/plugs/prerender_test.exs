defmodule Grid.PrerenderTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias Grid.Plugs.Prerender

  @bot_agent "twitterbot"
  @browser_agent "Mozilla/5.0"

  defp call(conn, url \\ :mock) do
    Prerender.call(conn, [service_url: url])
  end

  test "passthrough: not a GET" do
    conn = conn(:post, "https://example.com/")
      |> call

    refute conn.halted
  end

  test "passthrough: no user agent" do
    conn = conn(:get, "https://example.com/")
      |> call

    refute conn.halted
  end

  test "passthrough: not a bot" do
    conn = conn(:get, "https://example.com/")
      |> put_req_header("user-agent", @browser_agent)
      |> call

    refute conn.halted
  end

  test "prerender: is a bot" do
    conn = conn(:get, "https://example.com/")
      |> put_req_header("user-agent", @bot_agent)
      |> call

    assert conn.halted
  end

  test "prerender: is a bufferbot" do
    conn = conn(:get, "https://example.com/")
      |> put_req_header("user-agent", "not-empty")
      |> put_req_header("x-bufferbot", "bufferbot")
      |> call

    assert conn.halted
  end

  test "prerender: is using _escaped_fragment_" do
    conn = conn(:get, "https://example.com/?_escaped_fragment_=")
      |> put_req_header("user-agent", "googlebot")
      |> call

    assert conn.halted
  end

  test "prerender: is not an ignored extension" do
    conn = conn(:get, "https://example.com/index.html")
      |> put_req_header("user-agent", @bot_agent)
      |> call

    assert conn.halted
  end

  test "passthrough: is an ignored extension" do
    conn = conn(:get, "https://example.com/js/app.js")
      |> put_req_header("user-agent", @bot_agent)
      |> call

    refute conn.halted
  end

  test "should gunzip content from prerender service" do
    body = "Mocked pre-renderer"
    response = %{
      body: :zlib.gzip(body),
      status_code: 200,
      headers: [
        {"content-type", "text/html;charset=UTF-8"},
        {"Content-Encoding", "gzip"}
      ]
    }

    with_mock HTTPoison, [get!: fn(_, _, _) -> response end] do
      conn = conn(:get, "https://example.com/")
        |> put_req_header("user-agent", @bot_agent)
        |> call("http://mocked.io")

      assert conn.halted
      assert body == conn.resp_body
    end
  end
end
