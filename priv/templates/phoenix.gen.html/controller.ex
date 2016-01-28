defmodule <%= module %>Controller do
  use <%= base %>.Web, :controller

  alias <%= module %>
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "<%= human %>"
  plug :scrub_params, <%= inspect singular %> when action in [:create, :update]

  def index(conn, _) do
    <%= plural %> = Repo.all(<%= alias %>)
    render(conn, "index.html", <%= plural %>: <%= plural %>)
  end

  def new(conn, _) do
    changeset = <%= alias %>.changeset(%<%= alias %>{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{<%= inspect singular %> => <%= singular %>_params}) do
    changeset = <%= alias %>.changeset(%<%= alias %>{}, <%= singular %>_params)

    case Repo.insert(changeset) do
      {:ok, _<%= singular %>} ->
        conn
        |> put_flash(:info, "<%= human %> created successfully.")
        |> redirect(to: <%= singular %>_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    <%= singular %> = conn.assigns.<%= singular %>
    render(conn, "show.html", <%= singular %>: <%= singular %>)
  end

  def edit(conn, _) do
    <%= singular %> = conn.assigns.<%= singular %>
    changeset = <%= alias %>.changeset(<%= singular %>)
    render(conn, "edit.html", <%= singular %>: <%= singular %>, changeset: changeset)
  end

  def update(conn, %{<%= inspect singular %> => <%= singular %>_params}) do
    <%= singular %> = conn.assigns.<%= singular %>
    changeset = <%= alias %>.changeset(<%= singular %>, <%= singular %>_params)

    case Repo.update(changeset) do
      {:ok, <%= singular %>} ->
        conn
        |> put_flash(:info, "<%= human %> updated successfully.")
        |> redirect(to: <%= singular %>_path(conn, :show, <%= singular %>))
      {:error, changeset} ->
        render(conn, "edit.html", <%= singular %>: <%= singular %>, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.<%= singular %>)

    conn
    |> put_flash(:info, "<%= human %> deleted successfully.")
    |> redirect(to: <%= singular %>_path(conn, :index))
  end
end
