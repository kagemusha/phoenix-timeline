defmodule PhoenixTimeline.Api.GameView do
  use PhoenixTimeline.Web, :view

  attributes [:id, :code]

  has_many :players,
    serializer: PhoenixTimeline.Api.PlayerView,
    include: true

end
