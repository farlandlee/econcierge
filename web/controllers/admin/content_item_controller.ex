defmodule Grid.Admin.ContentItemController do
  use Grid.Web, :controller

  alias Grid.ContentItem
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Content Item"
  plug :scrub_params, "content_item" when action in [:create, :update]

  @assign_model_actions [:show, :edit, :update, :delete]
  plug Plugs.AssignModel, ContentItem when action in @assign_model_actions

  def index(conn, _) do
    content_items = Repo.all(ContentItem)
    render(conn, "index.html", content_items: content_items)
  end

  def edit(conn, _) do
    content_item = conn.assigns.content_item
    changeset = ContentItem.changeset(content_item)
    render(conn, "edit.html", content_item: content_item, changeset: changeset)
  end

  def update(conn, %{"content_item" => content_item_params}) do
    content_item = conn.assigns.content_item
    changeset = ContentItem.changeset(content_item, content_item_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Content item updated successfully.")
        |> redirect(to: admin_content_item_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", content_item: content_item, changeset: changeset)
    end
  end
end
