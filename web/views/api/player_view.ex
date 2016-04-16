defmodule PhoenixTimeline.Api.PlayerView do
  use PhoenixTimeline.Web, :view

  def render("player.json", %{player: player}) do
    game = player.game
    %{player:
      %{
        id: player.id,
        name: player.name,
        game: %{
          id: game.id,
          name: game.name,
          code: game.code
        }
      }
    }
  end

end
