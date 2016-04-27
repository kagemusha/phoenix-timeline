defmodule PhoenixTimeline.Router do
  use PhoenixTimeline.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixTimeline do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/cards", CardController
  end

  # Other scopes may use custom stacks.
   scope "/api", PhoenixTimeline do
     pipe_through :api
    resources "/games", Api.GameController, except: [:new, :edit]
    resources "/players", Api.PlayerController, except: [:new, :edit]
    resources "/cards", Api.CardController, except: [:new, :edit]
   end
end
