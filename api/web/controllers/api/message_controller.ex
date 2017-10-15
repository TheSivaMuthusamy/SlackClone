defmodule SlackClone.MessageController do
  use SlackClone.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: SlackClone.SessionController

  def index(conn, params) do
    last_seen_id = params["last_seen_id"] || 0
    room = Repo.get!(SlackClone.Room, params["room_id"])

    page =
      SlackClone.Message
      |> where([m], m.room_id == ^room.id)
      |> where([m], m.id < ^last_seen_id)
      |> order_by([desc: :inserted_at, desc: :id])
      |> preload(:user)
      |> SlackClone.Repo.paginate()

    render(conn, "index.json", %{messages: page.entries, pagination: SlackClone.PaginationHelpers.pagination(page)})
  end
end