defmodule SlackClone.RoomChannel do
  use SlackClone.Web, :channel

  def join("rooms:" <> room_id, _params, socket) do
    room = Repo.get!(SlackClone.Room, room_id)

    page =
      SlackClone.Message
      |> where([m], m.room_id == ^room.id)
      |> order_by([desc: :inserted_at, desc: :id])
      |> preload(:user)
      |> SlackClone.Repo.paginate()

    response = %{
      room: Phoenix.View.render_one(room, SlackClone.RoomView, "room.json"),
      messages: Phoenix.View.render_many(page.entries, SlackClone.MessageView, "message.json"),
      pagination: SlackClone.PaginationHelpers.pagination(page)
    }

    {:ok, response, assign(socket, :room, room)}
  end

  def handle_in("new_message", params, socket) do
    changeset =
      socket.assigns.room
      |> build_assoc(:messages, user_id: socket.assigns.current_user.id)
      |> SlackClone.Message.changeset(params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, Phoenix.View.render(SlackClone.ChangesetView, "error.json", changeset: changeset)}, socket}
    end
  end

  def terminate(_reason, socket) do
    {:ok, socket}
  end

  defp broadcast_message(socket, message) do
    message = Repo.preload(message, :user)
    rendered_message = Phoenix.View.render_one(message, SlackClone.MessageView, "message.json")
    broadcast!(socket, "message_created", rendered_message)
  end
end