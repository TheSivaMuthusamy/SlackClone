defmodule SlackClone.Router do
  use SlackClone.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", SlackClone do
    pipe_through :api

    post "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
    post "/sessions/refresh", SessionController, :refresh
    resources "/users", UserController, only: [:create]
    get "/users/:id/rooms", UserController, :rooms
    resources "/rooms", RoomController, only: [:index, :create] do
      resources "/messages", MessageController, only: [:index]
    end
    post "/rooms/:id/join", RoomController, :join
  end
end
