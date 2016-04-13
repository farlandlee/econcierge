defmodule Grid.Admin.Activity.ImageView do

  def render(template, assigns) do
    assigns = assigns
      |> Map.put(:image_path, :admin_activity_image_path)
      |> Map.put(:ancestor_path, :admin_activity_path)
      |> Map.put(:ancestors, [assigns.activity])
      |> Map.delete(:activity)
      
    Grid.Admin.ImageView.render(template, assigns)
  end
end
