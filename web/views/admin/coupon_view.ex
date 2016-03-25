defmodule Grid.Admin.CouponView do
  use Grid.Web, :view

  def checkbox_icon(true), do: icon("check")
  def checkbox_icon(false), do: icon("unchecked")
  defp icon(class) do
    ~E"""
    <span class="glyphicon glyphicon-<%= class %>"></span>
    """
  end
end
