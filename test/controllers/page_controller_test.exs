defmodule Grid.PageControllerTest do
  use Grid.ConnCase

  test "GET /" do
    product = Factory.create(:product)
    product2 = Factory.create(:product)

    another_activity = Factory.create(:activity)

    conn = get conn(), "/"
    response = html_response(conn, 200)
    assert response =~ product.experience.activity.name
    assert response =~ product2.experience.activity.name
    refute response =~ another_activity.name
  end
end
