defmodule PhoenixTimeline.Api.GameView do
  use PhoenixTimeline.Web, :view

  def render("created_game.json", %{game: game}) do
    [player] = game.players
    %{game:
      %{
        id: game.id,
        code: game.code,
        players: [%{
                    id: player.id,
                    name: player.name,
                    is_creator: true,
                    cards_remaining: player.cards_remaining,
                    total_cards: player.total_cards
        }]
      }
    }
  end
end
