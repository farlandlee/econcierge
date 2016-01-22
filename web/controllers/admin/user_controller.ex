defmodule Grid.Admin.UserController do
  use Grid.Web, :controller

  alias Grid.User
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Users"
  plug Plugs.Breadcrumb, index: User

  def index(conn, _) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end
end
