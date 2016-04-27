defmodule PhoenixTimeline.Api.PlayerView do
  use PhoenixTimeline.Web, :view

  def render("player_with_game.json", %{player: player}) do
    player = Repo.preload player, :game
    game = player.game
    %{player:
      %{
        id: player.id,
        name: player.name,
        token: player.token,
        game: game.id,
      },
      game: [%{
        id: game.id,
        name: game.name,
        code: game.code
      }]
    }
  end

end
