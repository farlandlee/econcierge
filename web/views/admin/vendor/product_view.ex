defmodule Grid.Admin.Vendor.ProductView do
  use Grid.Web, :view

  def check_icon(true), do: check_icon("check")
  def check_icon(false), do: check_icon("unchecked")
  def check_icon(class) do
    tag :span, class: "glyphicon glyphicon-#{class}"
  end
end
