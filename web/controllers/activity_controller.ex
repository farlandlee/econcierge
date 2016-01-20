defmodule Grid.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity
  alias Grid.Category
  alias Grid.Vendor
  alias Grid.Experience

  plug Grid.Plugs.AssignAvailableActivities
  plug :activity_assigns when action in [
    :vendors_by_activity_slug,
    :vendors_by_activity_and_category_slugs,
    :experiences_by_activity_slug,
    :experiences_by_activity_and_category_slugs
  ]

  def show(conn, %{"activity" => %{"id" => ""}}), do: redirect(conn, to: page_path(conn, :index))
  def show(conn, %{"activity" => %{"id" => id, "target" => target}}) when target in ["vendors", "experiences"] do
    activity_slug = Repo.one!(from a in Activity, where: a.id == ^id, select: a.slug)
    redirect(conn, to: activity_path(conn, String.to_existing_atom("#{target}_by_activity_slug"), activity_slug))
  end

  def vendors_by_activity_slug(conn, %{"activity_slug" => _}) do
    vendors = Repo.all(
      from v in Vendor,
      join: p in assoc(v, :products),
      join: a in assoc(p, :activity),
      where: p.published == true,
      where: a.id == ^conn.assigns.activity.id,
      distinct: true,
      preload: :default_image
    )

    render(conn, "show.html", items: vendors, category: nil, target: :vendors)
  end

  def vendors_by_activity_and_category_slugs(conn, %{"activity_slug" => _, "category_slug" => category_slug}) do
    category = Repo.get_by!(Category, slug: category_slug)

    # Load all unique vendors offering products for the specified
    # activity and category.
    vendors = Repo.all(
      from v in Vendor,
      join: p in assoc(v, :products),
      join: c in assoc(p, :categories),
      join: a in assoc(p, :activity),
      where: c.id == ^category.id,
      where: a.id == ^conn.assigns.activity.id,
      where: p.published == true,
      distinct: true,
      preload: :default_image
    )

    render(conn, "show.html", items: vendors, category: category, target: :vendors)
  end

  def experiences_by_activity_slug(conn, %{"activity_slug" => _}) do
    experiences = Repo.all(
      from e in Experience,
      join: p in assoc(e, :products),
      where: e.activity_id == ^conn.assigns.activity.id,
      where: p.published == true,
      distinct: true,
      preload: :image
    )

    render(conn, "show.html", items: experiences, category: nil, target: :experiences)
  end

  def experiences_by_activity_and_category_slugs(conn, %{"activity_slug" => _, "category_slug" => category_slug}) do
    category = Repo.get_by!(Category, slug: category_slug)

    experiences = Repo.all(
      from e in Experience,
      join: p in assoc(e, :products),
      join: c in assoc(p, :categories),
      where: c.id == ^category.id,
      where: e.activity_id == ^conn.assigns.activity.id,
      where: p.published == true,
      distinct: true,
      preload: :image
    )

    render(conn, "show.html", items: experiences, category: category, target: :experiences)
  end

  def activity_assigns(conn, _) do
    slug = conn.params["activity_slug"]
    activity = Repo.get_by!(Activity, slug: slug)

    categories = Repo.all(
      from c in Category,
      join: p in assoc(c, :products),
      join: a in assoc(p, :activity),
      where: a.id == ^activity.id,
      where: p.published == true,
      distinct: true
    )

    conn
    |> assign(:activity, activity)
    |> assign(:categories, categories)
  end
end
