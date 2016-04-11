defmodule PhoenixTimeline.Api.GameView do
  use PhoenixTimeline.Web, :view

  attributes [:id, :code]

  has_many :players,
    serializer: PhoenixTimeline.Api.PlayerView,
    include: true

  has_one :creator,
    serializer: PhoenixTimeline.Api.PlayerView,
    include: true

#   def games(player, _conn) do
#     Game.for_player(player)
#   end
end
