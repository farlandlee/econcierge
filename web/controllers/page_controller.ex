defmodule Grid.PageController do
  use Grid.Web, :controller

  alias Grid.Activity

  def index(conn, _params) do
    activities = Repo.all(Activity)
    render(conn, "index.html", activities: activities)
  end
end
