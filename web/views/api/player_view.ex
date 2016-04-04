defmodule PhoenixTimeline.Api.PlayerView do
  use PhoenixTimeline.Web, :view

  attributes [:id, :name]

  has_one :game,
    serializer: PhoenixTimeline.Api.GameView,
    include: true #,
end
