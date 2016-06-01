defmodule Grid.Admin.Kiosk.SlideControllerTest do
  use Grid.ConnCase

  alias Grid.Slide
  @valid_attrs %{name: "Slide Name", action_link: "http://test.com/book-it", action_label: "Book", photo_url: "http://test.com/image.jpeg", title: "some content", title_label: "some content"}
  @invalid_attrs %{action_label: nil}

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_slide_path(conn, :new)
    assert html_response(conn, 200) =~ "New Slide"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_slide_path(conn, :create), slide: @valid_attrs
    assert redirected_to(conn) == admin_slide_path(conn, :index)
    assert Repo.get_by(Slide, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_slide_path(conn, :create), slide: @invalid_attrs
    assert html_response(conn, 200) =~ "New Slide"
  end

  test "shows chosen resource", %{conn: conn} do
    slide = Factory.create(:slide)
    conn = get conn, admin_slide_path(conn, :show, slide)
    assert html_response(conn, 200) =~ "Show Slide"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_slide_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    slide = Factory.create(:slide)
    conn = get conn, admin_slide_path(conn, :edit, slide)
    assert html_response(conn, 200) =~ "Edit Slide"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    slide = Factory.create(:slide)
    conn = put conn, admin_slide_path(conn, :update, slide), slide: @valid_attrs
    assert redirected_to(conn) == admin_slide_path(conn, :index)
    assert Repo.get_by(Slide, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    slide = Factory.create(:slide)
    conn = put conn, admin_slide_path(conn, :update, slide), slide: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Slide"
  end

  test "deletes chosen resource", %{conn: conn} do
    slide = Factory.create(:slide)
    conn = delete conn, admin_slide_path(conn, :delete, slide)
    assert redirected_to(conn) == admin_slide_path(conn, :index)
    refute Repo.get(Slide, slide.id)
  end
end
