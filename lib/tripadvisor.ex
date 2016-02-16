defmodule TripAdvisor.API do
  use HTTPoison.Base

  def get_location(id, key: key) do
    get "location/#{id}?key=#{key}"
  end

  #########################
  ## HTTPoison Callbacks ##
  #########################

  @endpoint "http://api.tripadvisor.com/api/partner/2.0/"
  def process_url(url) do
    @endpoint <> url
  end

  def process_response_body(body) do
    Poison.decode! body
  end
end
defmodule TripAdvisor do
  use GenServer

  alias TripAdvisor.API

  alias Grid.Repo
  alias Grid.Vendor

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def update_vendor(%Vendor{
    tripadvisor_location_id: nil,
    tripadvisor_should_update: true
  }), do:
    {:error, :tripadvisor_id_not_set}

  def update_vendor(%Vendor{tripadvisor_should_update: true} = vendor), do:
    GenServer.cast(__MODULE__, {:update_vendor, vendor})

  def update_vendor(%Vendor{}), do: :ok

  #########################
  ## GenServer Callbacks ##
  #########################

  def init([]) do
    case Grid.fetch_env(:tripadvisor_api_key) do
      :error             -> {:error, :tripadvisor_api_key_not_set}
      {:ok, key}         -> {:ok, key, :hibernate}
    end
  end

  if Mix.env() != :prod do
    def handle_cast({:update_vendor, _}, "disabled") do
      {:noreply, "disabled"}
    end
  end

  def handle_cast({:update_vendor, vendor}, key) do
    params = API.get_location(vendor.tripadvisor_location_id, key: key)
      |> parse_location_params

    vendor
    |> Vendor.tripadvisor_changeset(params)
    |> Repo.update!

    {:noreply, key}
  end

  defp parse_location_params({:ok, %{body: %{"error" => err}}}) do
    if err["type"] == "UnauthorizedException" do
      raise KeyError, message: "TripAdvisor API Error: #{err["message"]}"
    end
    # Yes, we're ignoring all other errors for now
  end

  defp parse_location_params({:ok, %{body: params}}) do
    %{
      tripadvisor_rating: params["rating"],
      tripadvisor_rating_image_url: params["rating_image_url"],
      tripadvisor_reviews_count: params["num_reviews"],
      tripadvisor_url: params["web_url"]
    }
  end
end
