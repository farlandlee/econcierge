defmodule Grid.PageTitle do
  import Plug.Conn
  import Phoenix.Controller, only: [action_name: 1]

   def init(default), do: default

   def call(conn, opts) do
     title = Keyword.get(opts, :title)
     action = action_name(conn)
     result = page_title(action, title)
     assign(conn, :page_title, result)
   end

   defp page_title(:show, title), do: "Show #{title}"
   defp page_title(:edit, title), do: "Edit #{title}"
   defp page_title(:update, title), do: "Edit #{title}"
   defp page_title(:new, title), do: "New #{title}"
   defp page_title(:create, title), do: "New #{title}"
   defp page_title(:index, title), do: "#{title} Listing"
   defp page_title(_, title), do: title
end
