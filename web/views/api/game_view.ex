defmodule PhoenixTimeline.Api.GameView do
  use PhoenixTimeline.Web, :view

  attributes [:id, :code]

  def render("index.json", %{games: games}) do
    %{data: render_many(games, PhoenixTimeline.Api.GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, PhoenixTimeline.Api.GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    %{id: game.id,
      code: game.code
     }
  end
end
