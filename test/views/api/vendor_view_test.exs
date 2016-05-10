defmodule Grid.Api.VendorViewTest do
  use Grid.ConnCase

  import Grid.Api.VendorView

  @rendered_keys ~w(
  id name description slug cancellation_policy_days
  tripadvisor_rating
  default_image
  )a
  test "render vendor" do
    vendor = Factory.create(:vendor,
      notification_email: "test@outpostjh.com",
      admin_notes: "admin_notes"
    )

    image = Factory.create_vendor_image(assoc_id: vendor.id)

    vendor = Grid.Vendor.changeset(vendor, %{default_image_id: image.id})
      |> Repo.update!
      |> Repo.preload(:default_image)

    rendered = render("vendor.json", %{vendor: vendor})

    # Renders expected keys
    for key <- @rendered_keys do
      assert_key(key, vendor, rendered)
    end

    # no extra keys
    assert Map.keys(rendered) |> Enum.count() == Enum.count(@rendered_keys)
  end

  defp assert_key(:default_image, vendor, rendered) do
    assert rendered.default_image.alt == vendor.default_image.alt
  end

  defp assert_key(key, vendor, rendered) do
    assert Map.has_key?(rendered, key)
    assert rendered[key] == Map.get(vendor, key)
  end
end
