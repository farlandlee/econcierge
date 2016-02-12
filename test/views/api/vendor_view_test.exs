defmodule Grid.Api.VendorViewTest do
  use Grid.ConnCase

  import Grid.Api.VendorView
  test "render vendor" do
    vendor = Factory.create(:vendor, notification_email: "test@outpostjh.com", admin_notes: "admin_notes")
    rendered = render("vendor.json", %{vendor: vendor})

    for not_rendered_key <- ~w(notification_email admin_notes)a do
      refute Map.has_key?(rendered, not_rendered_key)
      refute Map.get(vendor, not_rendered_key) in Map.values(rendered)
    end

    for key <- ~w(
    id name description slug cancellation_policy_days
    tripadvisor_rating tripadvisor_reviews_count tripadvisor_rating_image_url)a
    do
      assert Map.has_key?(rendered, key)
      assert rendered[key] == Map.get(vendor, key)
    end
  end
end
