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
        is_creator: player.is_creator,
        cards_remaining: player.cards_remaining,
        total_cards: player.total_cards

      },
      game: [%{
        id: game.id,
        name: game.name,
        code: game.code
      }]
    }
  end

end
