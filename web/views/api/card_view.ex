defmodule PhoenixTimeline.Api.CardView do
  use PhoenixTimeline.Web, :view

  def render("cards_with_date.json", %{cards: cards}) do
    Enum.map cards, &( render("card_with_date.json", %{card: &1}) )
  end

  def render("card_with_date.json", %{card: card}) do
    %{id: card.id, event: card.event, year: card.year, month: card.month}
  end

  def render("card_no_date.json", %{card: card}) do
    %{id: card.id, event: card.event}
  end

end
