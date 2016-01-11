defmodule Grid.Admin.UserController do
  use Grid.Web, :controller

  alias Grid.User

  plug Grid.Plugs.PageTitle, title: "Users"

  def index(conn, _) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end
end
