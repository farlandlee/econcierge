defmodule Grid.Admin.Kiosk.SlideControllerTest do
  use Grid.ConnCase

  alias Grid.Slide
  @valid_attrs %{action_link: "http://test.com/book-it", action_label: "Book", photo_url: "http://test.com/image.jpeg", title: "some content", title_label: "some content"}
  @invalid_attrs %{action_label: nil}

  setup do
    kiosk = Factory.create(:kiosk)

    {:ok, kiosk: kiosk}
  end

  test "renders form for new resources", %{conn: conn, kiosk: kiosk} do
    conn = get conn, admin_kiosk_slide_path(conn, :new, kiosk)
    assert html_response(conn, 200) =~ "New Slide"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, kiosk: kiosk} do
    conn = post conn, admin_kiosk_slide_path(conn, :create, kiosk), slide: @valid_attrs
    assert redirected_to(conn) == admin_kiosk_path(conn, :show, kiosk)
    assert Repo.get_by(Slide, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, kiosk: kiosk} do
    conn = post conn, admin_kiosk_slide_path(conn, :create, kiosk), slide: @invalid_attrs
    assert html_response(conn, 200) =~ "New Slide"
  end

  test "shows chosen resource", %{conn: conn, kiosk: kiosk} do
    slide = Factory.create(:slide, kiosk: kiosk)
    conn = get conn, admin_kiosk_slide_path(conn, :show, kiosk, slide)
    assert html_response(conn, 200) =~ "Show Slide"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, kiosk: kiosk} do
    assert_error_sent 404, fn ->
      get conn, admin_kiosk_slide_path(conn, :show, kiosk, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, kiosk: kiosk} do
    slide = Factory.create(:slide, kiosk: kiosk)
    conn = get conn, admin_kiosk_slide_path(conn, :edit, kiosk, slide)
    assert html_response(conn, 200) =~ "Edit Slide"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, kiosk: kiosk} do
    slide = Factory.create(:slide)
    conn = put conn, admin_kiosk_slide_path(conn, :update, kiosk, slide), slide: @valid_attrs
    assert redirected_to(conn) == admin_kiosk_path(conn, :show, kiosk)
    assert Repo.get_by(Slide, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, kiosk: kiosk} do
    slide = Factory.create(:slide, kiosk: kiosk)
    conn = put conn, admin_kiosk_slide_path(conn, :update, kiosk, slide), slide: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Slide"
  end

  test "deletes chosen resource", %{conn: conn, kiosk: kiosk} do
    slide = Factory.create(:slide, kiosk: kiosk)
    conn = delete conn, admin_kiosk_slide_path(conn, :delete, kiosk, slide)
    assert redirected_to(conn) == admin_kiosk_path(conn, :show, kiosk)
    refute Repo.get(Slide, slide.id)
  end
end
