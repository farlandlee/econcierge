defmodule Grid.Admin.SlideController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.Slide
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Slide"
  plug :scrub_params, "slide" when action in [:create, :update]

  @assign_model_actions [:show, :edit, :update, :delete]
  plug Plugs.AssignModel, Slide when action in @assign_model_actions

  plug Plugs.Breadcrumb, index: Slide
  plug Plugs.Breadcrumb, [show: Slide] when action in [:show, :edit]

  def index(conn, _) do
    slides = Slide
      |> order_by(:name)
      |> Repo.all

    token = conn.assigns.ga_access_token
    view_id = Grid.fetch_env!(:ga_view_id)

    case GoogleAnalytics.load_slide_clicks(token, view_id) do
      a when map_size(a) == 0 -> # Re-authenticate
        conn
        |> put_session(:redirected_from, conn.request_path)
        |> redirect(to: auth_path(conn, :login, "google"))
      a ->
        render(conn, "index.html", slides: slides, analytics: a)
    end
  end

  def new(conn, _) do
    changeset = Slide.changeset(%Slide{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"slide" => slide_params}) do
    changeset = Slide.changeset(%Slide{}, slide_params)

    case Repo.insert(changeset) do
      {:ok, _slide} ->
        conn
        |> put_flash(:info, "Slide created successfully.")
        |> redirect(to: admin_slide_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    slide = conn.assigns.slide
    render(conn, "show.html", slide: slide)
  end

  def edit(conn, _) do
    slide = conn.assigns.slide
    changeset = Slide.changeset(slide)
    render(conn, "edit.html", slide: slide, changeset: changeset)
  end

  def update(conn, %{"slide" => slide_params}) do
    slide = conn.assigns.slide
    changeset = Slide.changeset(slide, slide_params)

    case Repo.update(changeset) do
      {:ok, _slide} ->
        conn
        |> put_flash(:info, "Slide updated successfully.")
        |> redirect(to: admin_slide_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", slide: slide, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.slide)

    conn
    |> put_flash(:info, "Slide deleted successfully.")
    |> redirect(to: admin_slide_path(conn, :index))
  end
end
