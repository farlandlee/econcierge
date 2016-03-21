defmodule Grid.Plugs.Prerender do
  import Plug.Conn

  require Logger

  # googlebot, yahoo, and bingbot are not in this list because
  # we support _escaped_fragment_ and want to ensure people arent
  # penalized for cloaking.
  @crawler_user_agents ~w(
    baiduspider
    facebookexternalhit
    twitterbot
    rogerbot
    linkedinbot
    embedly
    bufferbot
    quora link preview
    showyoubot
    outbrain
    pinterest
    developers.google.com/+/web/snippet
    www.google.com/webmasters/tools/richsnippets
    slackbot
    vkShare
    W3C_Validator
    redditbot
    Applebot
  )

  @extensions_to_ignore ~w(
    .js
    .css
    .xml
    .less
    .png
    .jpg
    .jpeg
    .gif
    .pdf
    .doc
    .txt
    .ico
    .rss
    .zip
    .mp3
    .rar
    .exe
    .wmv
    .doc
    .avi
    .ppt
    .mpg
    .mpeg
    .tif
    .wav
    .mov
    .psd
    .ai
    .xls
    .mp4
    .m4a
    .swf
    .dat
    .dmg
    .iso
    .flv
    .m4v
    .torrent
  )

  def init(opts), do: opts

  def call(conn, opts) do
    service_url = Keyword.fetch!(opts, :service_url)
    service_token = Keyword.get(opts, :service_token)

    if should_show_prerendered_page(conn) do
      conn
      |> prerender(service_url, service_token)
      |> halt
    else
      conn
    end
  end

  defp should_show_prerendered_page(conn = %{method: "GET"}) do
    (
      is_bot(conn) ||
      is_using_escaped_fragment(conn) ||
      is_bufferbot(conn)
    ) && !ignored_extension(conn)
  end
  defp should_show_prerendered_page(_), do: false

  defp get_user_agent(conn) do
    case get_req_header(conn, "user-agent") do
      [] -> nil
      [agent] -> agent
    end
  end

  defp is_bot(conn = %Plug.Conn{}), do: get_user_agent(conn) |> is_bot
  defp is_bot(nil), do: false
  defp is_bot(user_agent) do
    agent = String.downcase(user_agent)
    Enum.find(@crawler_user_agents, false, &(String.contains?(agent, &1)))
  end

  defp is_bufferbot(conn), do: !Enum.empty?(get_req_header(conn, "x-bufferbot"))

  defp is_using_escaped_fragment(conn) do
    case fetch_query_params(conn) do
      %{query_params: %{"_escaped_fragment_" => _}} -> true
      _ -> false
    end
  end

  defp ignored_extension(%{request_path: path}) do
    Enum.find(@extensions_to_ignore, false, &(String.contains?(path, &1)))
  end


  defp prerender(conn, :mock, _) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, "Mocked pre-renderer")
  end
  defp prerender(conn, service_url, service_token) do
    page_uri = conn_to_uri(conn)
    headers = prerender_headers(conn, service_token)

    Logger.info "PRERENDER URI: #{service_url}/#{page_uri}"

    %{status_code: code, body: body, headers: headers}
      = HTTPoison.get!("#{service_url}/#{page_uri}", headers,
        follow_redirect: true,
        timeout: 10_000,
        recv_timeout: 10_000
      )

    if {"Content-Encoding", "gzip"} == List.keyfind(headers, "Content-Encoding", 0) do
      body = :zlib.gunzip(body)

      headers = Enum.filter(headers, fn
        {"Content-Encoding", _} -> false
        {"Content-Length", _} -> false
        _ -> true
      end)
    end

    conn
    |> merge_resp_headers(headers)
    |> send_resp(code, body)
  end

  defp prerender_headers(conn, nil) do
    [
      {"User-Agent", get_user_agent(conn)},
      {"Accept-Encoding", "gzip"}
    ]
  end
  defp prerender_headers(conn, service_token) do
    prerender_headers(conn, nil) ++ [{"X-Prerender-Token", service_token}]
  end

  defp conn_to_uri(%Plug.Conn{scheme: scheme, host: host, request_path: path, query_string: query}) do
    %URI{
      scheme: Atom.to_string(scheme),
      path: path,
      query: query,
      host: host,
      port: get_port(scheme)
    }
  end

  defp get_port(:https), do: 443
  defp get_port(:http), do: 80
end
