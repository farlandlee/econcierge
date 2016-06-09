defmodule Grid.Admin.ContentItemControllerTest do
  use Grid.ConnCase

  alias Grid.ContentItem
  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  setup do
    item = Factory.create(:content_item)
    {:ok, content_item: item}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_content_item_path(conn, :index)
    assert html_response(conn, 200) =~ "Content Item Listing"
  end

  test "renders form for editing chosen resource", %{conn: conn, content_item: item} do
    conn = get conn, admin_content_item_path(conn, :edit, item)
    assert html_response(conn, 200) =~ "Edit Content Item"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, content_item: item} do
    conn = put conn, admin_content_item_path(conn, :update, item), content_item: @valid_attrs
    assert redirected_to(conn) == admin_content_item_path(conn, :index)
    assert Repo.get_by(ContentItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    content_item = Repo.insert! %ContentItem{}
    conn = put conn, admin_content_item_path(conn, :update, content_item), content_item: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Content Item"
  end
end
