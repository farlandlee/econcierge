defmodule Grid.Admin.Kiosk.SlideController do
  use Grid.Web, :controller

  alias Grid.Slide
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Slide"
  plug :scrub_params, "slide" when action in [:create, :update]

  @assign_model_actions [:show, :edit, :update, :delete]
  plug Plugs.AssignModel, Slide when action in @assign_model_actions

  def index(conn, _) do
    redirect(conn, to: admin_kiosk_path(conn, :show, conn.assigns.kiosk, tab: "slides"))
  end

  def new(conn, _) do
    changeset = Slide.changeset(%Slide{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"slide" => slide_params}) do
    changeset = Slide.creation_changeset(slide_params, conn.assigns.kiosk.id)

    case Repo.insert(changeset) do
      {:ok, _slide} ->
        conn
        |> put_flash(:info, "Slide created successfully.")
        |> redirect(to: admin_kiosk_path(conn, :show, conn.assigns.kiosk))
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
        |> redirect(to: admin_kiosk_path(conn, :show, conn.assigns.kiosk))
      {:error, changeset} ->
        render(conn, "edit.html", slide: slide, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.slide)

    conn
    |> put_flash(:info, "Slide deleted successfully.")
    |> redirect(to: admin_kiosk_path(conn, :show, conn.assigns.kiosk))
  end
end
