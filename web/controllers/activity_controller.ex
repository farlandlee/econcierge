defmodule Grid.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity
  alias Grid.Category
  alias Grid.Vendor

  plug Grid.Plugs.AssignAvailableActivities
  plug :activity_assigns when action in [:show_by_slug, :show_by_slug_and_category]

  def show(conn, %{"activity" => %{"id" => ""}}), do: redirect(conn, to: "/")
  def show(conn, %{"activity" => %{"id" => id}}) do
    activity_slug = Repo.one!(from a in Activity, where: a.id == ^id, select: a.slug)
    redirect(conn, to: activity_path(conn, :show_by_slug, activity_slug))
  end

  def show_by_slug(conn, _) do
    vendors = Repo.all(
      from v in Vendor,
      join: p in assoc(v, :products),
      join: a in assoc(p, :activities),
      where: p.published == true,
      where: a.id == ^conn.assigns.activity.id,
      distinct: true,
      preload: :default_image
    )

    render(conn, "show.html", vendors: vendors, category: nil)
  end

  def show_by_slug_and_category(conn, %{"category_slug" => category_slug}) do
    category = Repo.get_by!(Category, slug: category_slug)

    # Load all unique vendors offering products for the specified
    # activity and category.
    vendors = Repo.all(
      from v in Vendor,
      join: p in assoc(v, :products),
      join: c in assoc(p, :categories),
      join: a in assoc(p, :activities),
      where: c.id == ^category.id,
      where: a.id == ^conn.assigns.activity.id,
      where: p.published == true,
      distinct: true,
      preload: :default_image
    )

    render(conn, "show.html", vendors: vendors, category: category)
  end

  def activity_assigns(conn, _) do
    slug = conn.params["activity_slug"]
    activity = Repo.get_by!(Activity, slug: slug)

    categories = Repo.all(
      from c in Category,
      join: p in assoc(c, :products),
      join: a in assoc(p, :activities),
      where: a.id == ^activity.id,
      where: p.published == true,
      distinct: true
    )

    conn
    |> assign(:activity, activity)
    |> assign(:categories, categories)
  end
end
