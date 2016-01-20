defmodule Grid.Arc do
  use Arc.Definition

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
    name = :crypto.strong_rand_bytes(16)
      |> Base.url_encode64
      |> binary_part(0, 16)

    new_path = System.tmp_dir() <> "/#{name}"
    File.copy(file.path, new_path)

    Task.async fn ->
      try do
        {:ok, _} = store({%{file | path: new_path}, context})
        url_scope = {image.filename, context}

        image
        |> Image.changeset(%{
          "original" => url(url_scope, :original),
          "medium" => url(url_scope, :medium)
        })
        |> Repo.update!
      after
        File.rm!(new_path)
      end
    end
  end

  #######################
  ## Arc impl. (priv)  ##
  #######################

  @acl :public_read
  @versions [:original, :medium]

  if Application.get_env(:grid, :env) == :test do
    def __storage, do: Arc.Storage.Local
  end

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:medium, _) do
    {:convert, "-strip -thumbnail 350x233^ -gravity center -extent 350x233 -format jpg"}
  end

  # Override the persisted filenames:
  def filename(version, {file, _scope}) do
    # replace the extension, as Arc re-adds it afterwards
    "#{version}-#{file.file_name}"
    |> String.split(".")
    |> List.delete_at(-1)
    |> Enum.join(".")
  end

  @doc """
    iex> Grid.Arc.storage_dir(nil, {nil, %Grid.Vendor{id: 1}})
    "vendor/1"
    iex> Grid.Arc.storage_dir(nil, {nil, %Grid.Activity{id: 1}})
    "activity/1"
  """
  def storage_dir(_version, {_file, %{__struct__: module, id: id}}) do
    "#{Phoenix.Naming.resource_name(module)}/#{id}"
  end

end
