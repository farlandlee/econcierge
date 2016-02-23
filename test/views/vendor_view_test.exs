defmodule Grid.VendorViewTest do
  use Grid.ConnCase, async: true

  alias Grid.VendorView
  alias Grid.Image

  test "gets placeholdit for no image" do
    assert "http://placehold.it/450x300" == VendorView.img_src(nil, "anything")
  end

  test "gets actual image source" do
    img = %Image{original: "http://something.com/original.jpg", medium: "http://something.com/medium.jpg"}
    assert "http://something.com/medium.jpg" == VendorView.img_src(img)
    assert "http://something.com/original.jpg" == VendorView.img_src(img, :original)
  end
end
