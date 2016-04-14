defmodule PhoenixTimeline.Api.PlayerView do
  use PhoenixTimeline.Web, :view

  attributes [:id, :name, :is_creator, :is_winner, :total_cards, :cards_remaining]

#  has_one :game,
#    serializer: PhoenixTimeline.Api.GameView,
#    include: true
end
