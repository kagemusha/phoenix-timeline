defmodule PhoenixTimeline.GameView do
  use PhoenixTimeline.Web, :view

  def render("index.json", %{game: game}) do
    %{data: render_many(game, PhoenixTimeline.GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, PhoenixTimeline.GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    %{id: game.id,
      code: game.code}
  end
end
