defmodule PhoenixTimeline.Api.GameView do
  use PhoenixTimeline.Web, :view

  attributes [:id, :code]

  has_many :players,
    links: [
      related: "/games/:id/players",
      self: "/games/:id/relationships/players"
    ]

   def games(player, _conn) do
     Game.for_player(player)
   end
end
