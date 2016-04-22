defmodule Grid.Arc do
  use Arc.Definition
  require Logger

  alias Grid.Image
  alias Grid.Repo

  # Public API yo

  @doc """
  Uploads the file, then updates the image with the upload's URL based on context.
  """
  @spec upload_image(Grid.Image.t, %{filename: String.t, path: String.t}, Ecto.Model) :: Task.t
  def upload_image(image, file, context) do
    # Make a copy because the tmp file for the process might not be around
    # after we spawn
    tmp_path = get_temp_path()
    File.copy(file.path, tmp_path)

    spawn fn ->
      monitored_upload(%{file | path: tmp_path}, image, context)
      File.rm!(tmp_path)
    end
  end

  # @doc """
  # Reprocesses the images for a given context, uploads the version, then updates the image with the URL based on context.
  # """
  def reprocess_images_for(context) do
    context = context |> Repo.preload(:images)

    for i <- context.images, i.error == false do
      case download_file(i.original) do
        {:ok, path} ->
          monitored_upload(%{filename: i.filename, path: path}, i, context)
          File.rm!(path)
        _ ->
          Logger.warn("Arc: Failed on Image #{i.id} for #{context.__struct__} #{context.id}")
      end
    end
  end

  defp monitored_upload(file, image, context) do
    {pid, ref} = spawn_monitor fn ->
      {:ok, _} = store({file, [context, image]})
      url_scope = {image.filename, [context, image]}

      image
      |> Image.source_changeset(%{
        "original" => url(url_scope, :original),
        "medium" => url(url_scope, :medium),
        "large" => url(url_scope, :large),
        "thumb" => url(url_scope, :thumb),
        "error" => false
      })
      |> Repo.update!
    end

    timeout = Application.get_env(:arc, :version_timeout, 15_000) + 2_000

    receive do
      {:DOWN, ^ref, :process, ^pid, :normal} -> :ok
      {:DOWN, ^ref, :process, ^pid, _reason} -> set_errored(image)
    after
      timeout -> set_errored(image)
    end
  end

  defp download_file(url) do
    case HTTPoison.get(url) do
      {:ok, response} ->
        path = get_temp_path()
        File.write!(path, response.body)
        {:ok, path}
      _ -> {:error, nil}
    end
  end

  defp set_errored(image) do
    image
    |> Image.changeset(%{"error" => true})
    |> Repo.update!
  end

  defp get_temp_path() do
    tmp_file = :crypto.strong_rand_bytes(8)
      |> Base.url_encode64
      |> binary_part(0, 8)

    "#{System.tmp_dir}/#{tmp_file}"
  end

  #######################
  ## Arc impl. (priv)  ##
  #######################

  @acl :public_read
  @versions [:original, :medium, :large, :thumb]

  if Application.get_env(:grid, :env) == :test do
    def __storage, do: Arc.Storage.Local
  end

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(version, _) when version in ~w(medium large thumb)a, do: resize_cmd(version)

  defp resize_cmd(version) do
    {w, h} = Image.dimensions(version)

    # Double the dimensions and compress quality to make images that look better
    # on all displays, including retina.
    # Based on: https://www.netvlies.nl/tips-updates/design-interactie/retina-revolution
    w = w * 2
    h = h * 2
    q = 70

    {:convert, "-quality #{q} -resize #{w}x#{h}^ -gravity center -extent #{w}x#{h} -format jpg"}
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  @doc """
    iex> storage_dir(nil, {nil, [%Grid.Vendor{id: 1}, %Grid.Image{id: 1}]})
    "vendor/1/image/1"
    iex> storage_dir(nil, {nil, [%Grid.Activity{id: 1}, %Grid.Image{id: 1}]})
    "activity/1/image/1"
  """
  def storage_dir(_version, {_file, [%{__struct__: module, id: id}, %Grid.Image{id: image_id}]}) do
    "#{Phoenix.Naming.resource_name(module)}/#{id}/image/#{image_id}"
  end

end
