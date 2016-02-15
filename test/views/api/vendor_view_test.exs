defmodule Grid.Api.VendorViewTest do
  use Grid.ConnCase

  import Grid.Api.VendorView

  @rendered_keys ~w(
  id name description slug cancellation_policy_days
  tripadvisor_url
  tripadvisor_rating
  tripadvisor_reviews_count
  tripadvisor_rating_image_url
  )a
  test "render vendor" do
    vendor = Factory.create(:vendor, notification_email: "test@outpostjh.com", admin_notes: "admin_notes")
    rendered = render("vendor.json", %{vendor: vendor})

    # Renders expected keys
    for key <- @rendered_keys do
      assert Map.has_key?(rendered, key)
      assert rendered[key] == Map.get(vendor, key)
    end

    # no extra keys
    assert Map.keys(rendered) |> Enum.count() == Enum.count(@rendered_keys)
  end
end
