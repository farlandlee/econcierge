defmodule Grid.Arc.Image do
  use Arc.Definition

  @acl :public_read
  @versions [:original, :medium]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:medium, _) do
    {:convert, "-strip -thumbnail 350x233^ -gravity center -extent 350x233 -format jpg"}
  end

  if Application.get_env(:grid, :env) == :test do
    def __storage, do: Arc.Storage.Local
  end

  # Override the persisted filenames:
  def filename(version, {file, scope}) do
    # replace the extension, as Arc re-adds it afterwards
    "#{version}-#{file.file_name}"
    |> String.split(".")
    |> List.delete_at(-1)
    |> Enum.join(".")
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, %Grid.Vendor{id: id}}) do
    "vendor/#{id}"
  end
end
