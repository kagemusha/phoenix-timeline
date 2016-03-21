defmodule PhoenixTimeline.Api.CardView do
  use PhoenixTimeline.Web, :view

  def render("index.json", %{cards: cards}) do
    %{data: render_many(cards, PhoenixTimeline.Api.CardView, "card.json")}
  end

  def render("show.json", %{card: card}) do
    %{data: render_one(card, PhoenixTimeline.Api.CardView, "card.json")}
  end

  def render("card.json", %{card: card}) do
    %{id: card.id,
      event: card.event,
      year: card.year}
  end
end
