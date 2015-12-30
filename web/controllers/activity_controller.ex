defmodule Grid.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity
  alias Grid.ActivityCategory
  alias Grid.Category
  alias Grid.Product
  alias Grid.ProductActivityCategory
  alias Grid.Vendor

  plug Grid.Plugs.AssignAvailableActivities
  plug :activity_assigns when action in [:show_by_slug, :show_by_slug_and_category]

  def show(conn, %{"activity" => %{"id" => id}}) do
    activity_slug = Repo.one!(from a in Activity, where: a.id == ^id, select: a.slug)
    redirect(conn, to: activity_path(conn, :show_by_slug, activity_slug))
  end

  def show_by_slug(conn, _) do
    vendors = Repo.all(
      from v in Vendor,
      join: p in Product, on: v.id == p.vendor_id,
      where: p.activity_id == ^conn.assigns.activity.id,
      distinct: true,
      preload: :default_image
    )

    render(conn, "show.html",
      activity: conn.assigns.activity,
      categories: conn.assigns.categories,
      vendors: vendors,
      category: nil
    )
  end

  def show_by_slug_and_category(conn, %{"category_slug" => category_slug}) do
    category = Repo.get_by!(Category, slug: category_slug)

    # Load all unique vendors offering products for the specified
    # activity and category.
    vendors = Repo.all(
      from v in Vendor,
      join: p in Product, on: v.id == p.vendor_id,
      join: pac in ProductActivityCategory, on: p.id == pac.product_id,
      join: ac in ActivityCategory, on: pac.activity_category_id == ac.id,
      where: p.activity_id == ^conn.assigns.activity.id,
      where: ac.category_id == ^category.id,
      distinct: true,
      preload: :default_image
    )

    render(conn, "show.html",
      activity: conn.assigns.activity,
      categories: conn.assigns.categories,
      vendors: vendors,
      category: category
    )
  end

  def activity_assigns(conn, _) do
    slug = conn.params["activity_slug"]
    activity = Repo.get_by!(Activity, slug: slug)

    categories = Repo.all(
      from c in Category,
      join: ac in ActivityCategory, on: c.id == ac.category_id,
      join: pac in ProductActivityCategory, on: ac.id == pac.activity_category_id,
      where: ac.activity_id == ^activity.id
    )

    conn
    |> assign(:activity, activity)
    |> assign(:categories, categories)
  end
end
