defmodule Grid.AuthController do
  use Grid.Web, :controller

  alias Grid.User

  def index(conn, _) do
    if conn.assigns.current_user do
      redirect(conn, to: admin_dashboard_path(conn, :index))
    else
      conn
      |> put_layout(false)
      |> render("index.html")
    end
  end

  def login(conn, %{"provider" => "google"}) do
    redirect conn, external: Google.authorize_url!(scope: "email profile")
  end
  def login(conn, _), do: invalid_provider(conn)

  def logout(conn, _) do
    conn
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(conn, %{"provider" => "google", "code" => code}) do
    user_params = Google.get_token!(code: code)
      |> Google.get_user!

    if user_params["hd"] == "outpostjh.com" do
      user = insert_or_update_user(user_params)

      redirect_to = get_session(conn, :redirected_from) || admin_dashboard_path(conn, :index)

      conn
      |> put_session(:user_id, user.id)
      |> delete_session(:redirected_from)
      |> configure_session(renew: true)
      |> redirect(to: redirect_to)
    else
      conn
      |> put_flash(:error, "Invalid email domain.")
      |> redirect(to: auth_path(conn, :index))
    end
  end
  def callback(conn, _), do: invalid_provider(conn)

  defp invalid_provider(conn) do
    conn
    |> put_flash(:error, "Provider not accepted.")
    |> redirect(to: auth_path(conn, :index))
  end

  defp insert_or_update_user(user_params) do
    case Repo.get_by(User, email: user_params["email"]) do
      nil  -> User.changeset(%User{}, user_params)
      user -> User.changeset(user,    user_params)
    end
    |> Repo.insert_or_update!
  end
end
